import React, { useState } from 'react'
import { Button, Container, Form } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { DeleteItemModal, ItemsPricingTopBar, ItemTotalPrice, QuoteCreation, ROUTES } from '../shared'
import { PcCategoryAccordion, PcItemAccordion, PcItemFormGroup, PcItemTextareaControl } from '../ui'
import { getCurrentStepId } from '../utils'

const initItemsData = [
  {
    id: '1',
    type: 'item',
    attributes: {
      name: 'Fixed price',
      description: '',
      category_id: 16,
      fixed_parameters: { Price: '2500' },
      pricing_options: {},
      is_disabled: false,
      is_fixed: true,
      is_open: false,
      is_selectable_options: false,
      open_parameters_label: [],
      formula_parameters: ['Price'],
      calculation_formula: 'Price',
    },
  },
  {
    id: '2',
    type: 'item',
    attributes: {
      name: 'Open parameter',
      description: '',
      category_id: 16,
      fixed_parameters: { Price: '2500' },
      pricing_options: {},
      is_disabled: false,
      is_fixed: false,
      is_open: true,
      is_selectable_options: false,
      open_parameters_label: [],
      formula_parameters: ['Price'],
      calculation_formula: 'Price',
    },
  },
  {
    id: '3',
    type: 'item',
    attributes: {
      name: 'Selectable',
      description: '',
      category_id: 16,
      fixed_parameters: {},
      pricing_options: {
        Tier: {
          '1-5': '100',
          '6-15': '200',
          '16+': '350',
        },
      },
      is_disabled: false,
      is_fixed: false,
      is_open: false,
      is_selectable_options: true,
      open_parameters_label: [],
      formula_parameters: ['Price'],
      calculation_formula: 'Price',
    },
  },
  // {
  //   "id": "4",
  //   "type": "item",
  //   "attributes": {
  //     "name": "Licences",
  //     "description": "yuyuy",
  //     "category_id": 16,
  //     "fixed_parameters": {},
  //     "pricing_options": {
  //       "Tier": {
  //         "1-5": "100",
  //         "6-15": "200",
  //         "16+": "350",
  //       },
  //     },
  //     "is_disabled": false,
  //     "is_fixed": false,
  //     "is_open": true,
  //     "is_selectable_options": true,
  //     "open_parameters_label": ["Users"],
  //     "formula_parameters": [],
  //     "calculation_formula": "Tier * Users",
  //   },
  // },
  // {
  //   "id": "5",
  //   "type": "item",
  //   "attributes": {
  //     "name": "Decision Success",
  //     "description": "",
  //     "category_id": 16,
  //     "fixed_parameters": {
  //       "Rate per hours": "100",
  //     },
  //     "pricing_options": {},
  //     "is_disabled": false,
  //     "is_fixed": true,
  //     "is_open": true,
  //     "is_selectable_options": false,
  //     "open_parameters_label": ["Hours"],
  //     "formula_parameters": ["Rate per hours", "Hours"],
  //     "calculation_formula": "Rate per hours * Hours",
  //   },
  // },
]

export const ItemsPricing = () => {
  const { navigate, queryParams, location } = useAppHooks()

  const [selectedCategories, setSelectedCategories] = useState([])
  const [expandedAccordions, setExpandedAccordions] = useState([]) // array of IDs
  const [isNotesShow, setIsNotesShow] = useState(false)
  const [notesValue, setNotesValue] = useState('')
  const [includeNotes, setIncludeNotes] = useState(false)
  const [categoryIdToDelete, setCategoryIdToDelete] = useState(null)
  const [isShowDeleteModal, setIsShowDeleteModal] = useState(false)
  const quoteId = queryParams.get('quote_id')
  const currentStepId = getCurrentStepId(location.pathname)
  const totalPrice = 0 // TODO: get total price from BE
  const notesIcon = notesValue.trim() ? 'noted' : 'note'

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
  const handleDownload = () => {
    // await fetchQuotes.update(quoteId, {
    //   quote: { step: STEPS.COMPLETED },
    // })
  }
  const handleBack = () => navigate(ROUTES.CUSTOMER_INFO)
  const handleIncludeNotes = (e) => setIncludeNotes(e.target.checked)
  const handleNotesValue = (e) => setNotesValue(e.target.value)

  return (
    <Container className={'wrapper pt-10 pb-8'}>
      <section className={'mb-12 px-8'}>
        <QuoteCreation currentStepId={currentStepId} />

        {/* Items & Pricing dashboard*/}
        <ItemsPricingTopBar
          totalPrice={totalPrice}
          selectedCategories={selectedCategories}
          setSelectedCategories={setSelectedCategories}
          expandAll={expandAll}
          collapseAll={collapseAll}
          expandedAccordions={expandedAccordions}
          showDeleteModal={showDeleteModal}
        />

        {selectedCategories.length === 0 && (
          <div className="text-center text-primary fst-italic py-6">Select one or more items to start your quote.</div>
        )}
      </section>

      <section className={'d-flex flex-column gap-4 mb-12'}>
        {selectedCategories.length > 0 &&
          selectedCategories.map((category) => {
            const categoryItems = initItemsData.filter((item) => item.attributes.category_id === category.id)

            return (
              <PcCategoryAccordion
                key={`category-${category.id}`}
                categoryName={category.name}
                isOpen={expandedAccordions.includes(category.id)}
                onToggle={() => handleToggle(category.id)}
                onDelete={() => showDeleteModal(category.id)}
              >
                <div className={'d-flex flex-column gap-6'}>
                  {categoryItems.map((item) => (
                    <PcItemAccordion
                      key={`item-${item.id}`}
                      itemName={item.attributes.name}
                      isNotesShow={isNotesShow}
                      setIsNotesShow={setIsNotesShow}
                      notesIcon={notesIcon}
                    >
                      <ItemTotalPrice itemData={item.attributes} className={''} />

                      {isNotesShow && (
                        <PcItemFormGroup label={'Notes'} itemType={'notes'}>
                          <PcItemTextareaControl
                            placeholder={''}
                            className={'mb-3'}
                            value={notesValue}
                            onChange={handleNotesValue}
                          />
                          <Form.Check
                            type={'checkbox'}
                            label={`Include notes with quote`}
                            className={'fs-10'}
                            checked={includeNotes}
                            onChange={handleIncludeNotes}
                          />
                        </PcItemFormGroup>
                      )}
                    </PcItemAccordion>
                  ))}
                </div>
              </PcCategoryAccordion>
            )
          })}
      </section>

      {/* Buttons section */}
      <section className={'d-flex justify-content-center align-items-center gap-4'}>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn'} onClick={handleBack}>
          Back
        </Button>
        <Button
          variant={'outline-primary'}
          className={'fw-bold pc-btn pc-btn-download'}
          onClick={handleDownload}
          disabled={true}
        >
          Download
        </Button>
      </section>

      {/*Modal for confirm delete/cancel category*/}
      <DeleteItemModal
        show={isShowDeleteModal}
        onHide={handleCancelDeleteCategory}
        onConfirmDelete={handleConfirmDeleteCategory}
      />
    </Container>
  )
}
