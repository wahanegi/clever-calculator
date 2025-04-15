import React, { useState } from 'react'
import { Button, Container, Form } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { ItemsPricingTopBar, ItemTotalPrice, QuoteCreation, ROUTES } from '../shared'
import { PcAccordion, PcItemAccordion, PcItemFormGroup, PcItemTextareaControl } from '../ui'
import { getCurrentStepId } from '../utils'

export const ItemsPricing = () => {
  const { navigate, queryParams, location } = useAppHooks()

  const [selectedCategories, setSelectedCategories] = useState([])
  const [expandedAccordions, setExpandedAccordions] = useState([]) // array of IDs
  const [isNotesShow, setIsNotesShow] = useState(false)
  const [notesValue, setNotesValue] = useState('')
  const [includeNotes, setIncludeNotes] = useState(false)

  const quoteId = queryParams.get('quote_id')
  const currentStepId = getCurrentStepId(location.pathname)
  const totalPrice = 123 // TODO: get total price from BE
  const notesIcon = notesValue.trim() ? 'noted' : 'note'

  const handleToggle = (id) => {
    setExpandedAccordions((prev) =>
      prev.includes(id) ? prev.filter(item => item !== id) : [...prev, id],
    )
  }
  const expandAll = () => setExpandedAccordions(selectedCategories.map(category => category.id))
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
    <Container className={'wrapper'}>
      <section className={'mb-8 px-6'}>
        <QuoteCreation currentStepId={currentStepId} />

        {/* Items & Pricing dashboard*/}
        <ItemsPricingTopBar
          totalPrice={totalPrice}
          selectedCategories={selectedCategories}
          setSelectedCategories={setSelectedCategories}
          expandAll={expandAll}
          collapseAll={collapseAll}
          expandedAccordions={expandedAccordions}
        />

        {selectedCategories.length === 0 &&
          (<div className="text-center text-muted py-5">
            Select one or more items to start your quote.
          </div>)
        }
      </section>

      <section className={'d-flex flex-column gap-4 mb-8'}>
        {selectedCategories.length > 0 && selectedCategories.map((category) => (
          <PcAccordion
            key={category.id}
            categoryName={category.name}
            isOpen={expandedAccordions.includes(category.id)}
            onToggle={() => handleToggle(category.id)}
          >
            {/*List of items */}
            <div className={'d-flex flex-column gap-5'}>
              {/*TODO: Example of Fixed Price. Will be changed after adding logic*/}
              <PcItemAccordion
                key={'fixed-price'}
                itemName={'Decision Success'}
                isNotesShow={isNotesShow}
                setIsNotesShow={setIsNotesShow}
                notesIcon={notesIcon}
              >
                <ItemTotalPrice name={''} className={'mb-4'} />

                {isNotesShow &&
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
                }
              </PcItemAccordion>
            </div>
          </PcAccordion>
        ))}
      </section>

      {/* Buttons section */}
      <section className={'d-flex justify-content-center align-items-center gap-4 mb-5'}>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn-back'} onClick={handleBack}>Back</Button>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn-download'} onClick={handleDownload}
                disabled={true}>Download</Button>
      </section>
    </Container>
  )
}
