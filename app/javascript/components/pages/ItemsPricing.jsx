import React, { useState, useEffect } from 'react'
import { Button, Container, Form } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { DeleteItemModal, ItemsPricingTopBar, ItemTotalPrice, QuoteCreation, ROUTES } from '../shared'
import { PcCategoryAccordion, PcItemAccordion, PcItemFormGroup, PcItemTextareaControl } from '../ui'
import { getCurrentStepId, normalizeApiCategories, normalizeApiItems } from '../utils'
import { fetchCategories } from '../services'

export const ItemsPricing = () => {
  const { navigate, queryParams, location } = useAppHooks()

  const [selectedCategories, setSelectedCategories] = useState([])
  const [expandedAccordions, setExpandedAccordions] = useState([])
  const [isShowDeleteModal, setIsShowDeleteModal] = useState(false)
  const [categoryIdToDelete, setCategoryIdToDelete] = useState(null)
  const [categories, setCategories] = useState([])
  const [items, setItems] = useState([])

  const [notesStates, setNotesStates] = useState({})

  const quoteId = queryParams.get('quote_id')
  const currentStepId = getCurrentStepId(location.pathname)
  const totalPrice = 0

  useEffect(() => {
    fetchCategories.index().then((res) => {
      const categories = normalizeApiCategories(res.data)
      const itemsData = normalizeApiItems(res.included)
      setCategories(categories)
      setItems(itemsData)
    })
  }, [])

  const showDeleteModal = (categoryId) => {
    setCategoryIdToDelete(categoryId)
    setIsShowDeleteModal(true)
  }
  const handleToggle = (id) => {
    setExpandedAccordions((prev) => (prev.includes(id) ? prev.filter((item) => item !== id) : [...prev, id]))
  }
  const handleConfirmDeleteCategory = () => {
    setSelectedCategories((prev) => prev.filter((category) => category.id !== categoryIdToDelete))
    setExpandedAccordions((prev) => prev.filter((id) => id !== categoryIdToDelete))
    setCategoryIdToDelete(null)
    setIsShowDeleteModal(false)
  }

  const handleCancelDeleteCategory = () => {
    setCategoryIdToDelete(null)
    setIsShowDeleteModal(false)
  }

  const expandAll = () => setExpandedAccordions(selectedCategories.map((category) => category.id))
  const collapseAll = () => setExpandedAccordions([])

  const handleNotesChange = (itemId, value) => {
    setNotesStates((prev) => ({
      ...prev,
      [itemId]: { ...(prev[itemId] || {}), note: value },
    }))
  }

  const handleIncludeNotesChange = (itemId, checked) => {
    setNotesStates((prev) => ({
      ...prev,
      [itemId]: { ...(prev[itemId] || {}), include: checked },
    }))
  }

  const toggleItemNotes = (itemId) => {
    setNotesStates((prev) => ({
      ...prev,
      [itemId]: { ...(prev[itemId] || {}), isNotesOpen: !prev[itemId]?.isNotesOpen },
    }))
  }

  const handleDownload = async () => {
    const notesToSend = Object.entries(notesStates).reduce((acc, [itemId, { note, include }]) => {
      if (include && note?.trim()) {
        acc.push({ item_id: itemId, note })
      }
      return acc
    }, [])

    console.log({ notesToSend })
  }

  const handleBack = () => navigate(ROUTES.CUSTOMER_INFO)

  return (
    <Container className={'wrapper pt-16'}>
      <section className={'mb-12 px-8'}>
        <QuoteCreation currentStepId={currentStepId} />

        <ItemsPricingTopBar
          totalPrice={totalPrice}
          selectedCategories={selectedCategories}
          setSelectedCategories={setSelectedCategories}
          expandAll={expandAll}
          collapseAll={collapseAll}
          expandedAccordions={expandedAccordions}
          showDeleteModal={showDeleteModal}
          categories={categories}
        />

        {selectedCategories.length === 0 && (
          <div className="text-center text-primary fst-italic py-6">Select one or more items to start your quote.</div>
        )}
      </section>

      <section className={'d-flex flex-column gap-4 mb-12'}>
        {selectedCategories.length > 0 &&
          selectedCategories.map((category) => {
            const categoryItems = items?.filter((item) => item.category_id === category.id)
            return (
              <PcCategoryAccordion
                key={`category-${category.id}`}
                categoryName={category.name}
                isOpen={expandedAccordions.includes(category.id)}
                onToggle={() => handleToggle(category.id)}
                onDelete={() => showDeleteModal(category.id)}
              >
                <div className={'d-flex flex-column gap-6'}>
                  {categoryItems.map((item) => {
                    const notesState = notesStates[item.id] || {}
                    const notesIcon = notesState.note?.trim() ? 'noted' : 'note'

                    return (
                      <PcItemAccordion
                        key={`item-${item.id}`}
                        itemName={item.name}
                        isNotesShow={notesState.isNotesOpen}
                        onToggleNotes={() => toggleItemNotes(item.id)}
                        notesIcon={notesIcon}
                      >
                        <ItemTotalPrice itemData={item} />

                        {notesState.isNotesOpen && (
                          <PcItemFormGroup label={'Notes'} paramType={'notes'}>
                            <PcItemTextareaControl
                              placeholder={''}
                              className={'mb-3 mt-9'}
                              value={notesState.note || ''}
                              onChange={(e) => handleNotesChange(item.id, e.target.value)}
                            />
                            <Form.Check
                              type={'checkbox'}
                              label={'Include notes with quote'}
                              className={'fs-10'}
                              checked={notesState.include || false}
                              onChange={(e) => handleIncludeNotesChange(item.id, e.target.checked)}
                            />
                          </PcItemFormGroup>
                        )}
                      </PcItemAccordion>
                    )
                  })}
                </div>
              </PcCategoryAccordion>
            )
          })}
      </section>

      <section className={'d-flex justify-content-center align-items-center gap-4 mb-4'}>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn'} onClick={handleBack}>
          Back
        </Button>
        <Button
          variant={'outline-primary'}
          className={'fw-bold pc-btn pc-btn-download'}
          onClick={handleDownload}
          disabled={selectedCategories.length === 0}
        >
          Download
        </Button>
      </section>

      <DeleteItemModal
        show={isShowDeleteModal}
        onHide={handleCancelDeleteCategory}
        onConfirmDelete={handleConfirmDeleteCategory}
      />
    </Container>
  )
}
