import React, { useState, useEffect } from 'react'
import { Button, Container, Form } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { DeleteItemModal, ItemsPricingTopBar, Item, QuoteCreation, ROUTES } from '../shared'
import { PcCategoryAccordion, PcItemAccordion, PcItemFormGroup, PcItemTextareaControl } from '../ui'
import { getCurrentStepId, totalFinalPrice } from '../utils'
import { fetchQuoteItems, fetchSelectableOptions } from '../services'

export const ItemsPricing = () => {
  const { navigate, queryParams, location } = useAppHooks()
  const quoteId = queryParams.get('quote_id')
  const currentStepId = getCurrentStepId(location.pathname)

  const [selectedOptions, setSelectedOptions] = useState([])
  const [expandedAccordions, setExpandedAccordions] = useState([])
  const [isShowDeleteModal, setIsShowDeleteModal] = useState(false)
  const [removeSelectedOption, setRemoveSelectedOption] = useState({})
  const [selectableOptions, setSelectableOptions] = useState([])
  const [notesStates, setNotesStates] = useState({})

  const isSelectedOptionsEmpty = selectedOptions.length === 0
  console.log('selectedOptions', selectedOptions)

  useEffect(() => {
    fetchSelectableOptions.index().then((data) => {
      setSelectableOptions(data)
    })
    fetchQuoteItems.index(quoteId).then((data) => {
      setSelectedOptions(data)
    })
  }, [])

  const showDeleteModal = (option) => {
    setRemoveSelectedOption(option)
    setIsShowDeleteModal(true)
  }

  const handleToggle = (id) => {
    setExpandedAccordions((prev) => (prev.includes(id) ? prev.filter((item) => item !== id) : [...prev, id]))
  }

  const handleConfirmDelete = () => {
    const quoteItemIds = removeSelectedOption.quote_items.map(item => item.id)

    fetchQuoteItems.deleteSelected(quoteId, quoteItemIds).then(() => {
      setSelectedOptions(selectedOptions.filter((option) => option.id !== removeSelectedOption.id && option.type === removeSelectedOption.type))
      setExpandedAccordions((prev) => prev.filter((id) => id !== removeSelectedOption.id))
      setRemoveSelectedOption(null)
      setIsShowDeleteModal(false)
    })
  }

  const handleCancelDeleteCategory = () => {
    setRemoveSelectedOption(null)
    setIsShowDeleteModal(false)
  }

  const expandAll = () => setExpandedAccordions(selectedOptions.map((selectedOption) => selectedOption.id))
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

  const EmptyQuotePrompt = () =>
    isSelectedOptionsEmpty && (
      <div className="text-center text-primary fst-italic py-6">
        Select one or more items to start your quote.
      </div>
    )

  return (
    <Container className={'wrapper pt-16'}>
      <section className={'mb-12 px-8'}>
        <QuoteCreation currentStepId={currentStepId} />

        <ItemsPricingTopBar
          quoteId={quoteId}
          totalPrice={selectedOptions.reduce((total, option) => total + parseFloat(totalFinalPrice(option?.quote_items || [])), 0).toFixed(2)}
          selectedOptions={selectedOptions}
          setSelectedOptions={setSelectedOptions}
          expandAll={expandAll}
          collapseAll={collapseAll}
          expandedAccordions={expandedAccordions}
          showDeleteModal={showDeleteModal}
          selectableOptions={selectableOptions}
        />

        <EmptyQuotePrompt />
      </section>

      <section className={'d-flex flex-column gap-4 mb-12'}>
        {selectedOptions.map((selectedOption) =>
          <PcCategoryAccordion
            key={`category-${selectedOption.id}`}
            categoryName={selectedOption.name}
            isOpen={expandedAccordions.includes(selectedOption.id)}
            onToggle={() => handleToggle(selectedOption.id)}
            onDelete={() => showDeleteModal(selectedOption)}
            categoryPrice={totalFinalPrice(selectedOption.quote_items)}
          >
            <div className={'d-flex flex-column gap-6'}>
              {selectedOption.quote_items.map((item) => {
                const notesState = notesStates[item.id] || {}
                const notesIcon = notesState.note?.trim() ? 'noted' : 'note'

                return (
                  <PcItemAccordion
                    key={`quote-item-${item.id}`}
                    itemName={item.attributes.item.name}
                    isNotesShow={notesState.isNotesOpen}
                    onToggleNotes={() => toggleItemNotes(item.id)}
                    notesIcon={notesIcon}
                    quotePrice={item.attributes.final_price}>
                    <Item itemData={item}
                          quoteId={quoteId}
                          selectedOptions={selectedOptions}
                          setSelectedOptions={setSelectedOptions} />

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
          </PcCategoryAccordion>)}
      </section>

      <section className={'d-flex justify-content-center align-items-center gap-4 mb-4'}>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn'} onClick={handleBack}>
          Back
        </Button>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn pc-btn-download'}
                onClick={handleDownload} disabled={isSelectedOptionsEmpty}>
          Download
        </Button>
      </section>

      <DeleteItemModal
        show={isShowDeleteModal}
        onHide={handleCancelDeleteCategory}
        onConfirmDelete={handleConfirmDelete}
      />
    </Container>
  )
}
