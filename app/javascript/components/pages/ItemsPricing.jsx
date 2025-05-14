import React, { useState, useEffect } from 'react'
import { Button, Container, Form } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { DeleteItemModal, ItemsPricingTopBar, Item, QuoteCreation, ROUTES } from '../shared'
import { PcCategoryAccordion, PcItemAccordion, PcItemFormGroup, PcItemTextareaControl } from '../ui'
import { getCurrentStepId, totalFinalPrice, triggerFileDownload } from '../utils'
import { fetchQuoteItems, fetchQuotes, fetchSelectableOptions } from '../services'
import { AlertModal } from '../shared/AlertModal'

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
  const [isShowCancelQuoteAlertModal, setIsShowCancelQuoteAlertModal] = useState(false)
  const [isShowResetQuoteAlertModal, setIsShowResetQuoteAlertModal] = useState(false)

  const isSelectedOptionsEmpty = selectedOptions.length === 0
  const totalPrice = selectedOptions.reduce((total, option) => total + parseFloat(totalFinalPrice(option?.quote_items || [])), 0).toFixed(2)


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
      setSelectedOptions(selectedOptions.filter(((option) => !(removeSelectedOption.id === option.id && removeSelectedOption.type === option.type))))
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

  const handleFileDownload = () => {
    fetchQuotes.generateFile(quoteId)
      .then((blob) => {
        triggerFileDownload(blob, `quote_${quoteId}.docx`)
      }).catch((err) => {
      console.error('File download failed', err)
    })
  }

  const handleCustomerBack = () => {
    setIsShowCancelQuoteAlertModal(true)
  }

  const handleQuoteReset = () => {
    setIsShowResetQuoteAlertModal(true)
  }

  const EmptyQuotePrompt = () => isSelectedOptionsEmpty && (
    <div className="text-center text-primary fst-italic py-6">
      Select one or more items to start your quote.
    </div>
  )

  const CancelQuoteAlertModal = () => {
    const handleCancel = () => {
      console.log('handleCancel in CancelQuoteAlertModal')
      setIsShowCancelQuoteAlertModal(false)
    }

    const handleConfirm = () => {
      console.log('handleConfirm in CancelQuoteAlertModal')
      setIsShowCancelQuoteAlertModal(false)

      fetchQuotes.destroy(quoteId).then(() => {
        navigate(ROUTES.CUSTOMER_INFO)
      })
    }

    return (
      <AlertModal show={isShowCancelQuoteAlertModal}
                  onCancel={handleCancel}
                  onConfirm={handleConfirm}
                  confirmButtonText={'Go back'}
                  title={'Are you sure?'}
                  bodyText={'Do you really want to go back and cancel the current quote? This action will discard all progress and start a new quote.'} />
    )
  }

  const ResetQuoteAlertModal = () => {
    const handleCancel = () => {
      console.log('handleCancel in ResetQuoteAlertModal')
      setIsShowResetQuoteAlertModal(false)
    }

    const handleConfirm = () => {
      console.log('handleConfirm in ResetQuoteAlertModal')
      setIsShowResetQuoteAlertModal(false)

      fetchQuotes.reset(quoteId).then(() => {
        setSelectedOptions([])
        setExpandedAccordions([])
        setNotesStates({})
      })
    }

    return (
      <AlertModal show={isShowResetQuoteAlertModal}
                  onCancel={handleCancel}
                  onConfirm={handleConfirm}
                  confirmButtonText={'Reset'}
                  title={'Are you sure?'}
                  bodyText={'Do you really want to reset all selected items? You will be able to start over within this quote.'} />
    )
  }

  return (
    <Container className={'wrapper pt-16'}>
      <section className={'mb-12 px-8'}>
        <QuoteCreation currentStepId={currentStepId}
                       onReset={handleQuoteReset}
                       disabledResetButton={isSelectedOptionsEmpty}
        />

        <ItemsPricingTopBar
          quoteId={quoteId}
          totalPrice={totalPrice}
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
                    item={item}
                    quoteId={quoteId}
                    setSelectedOptions={setSelectedOptions}
                    isNotesShow={notesState.isNotesOpen}
                    onToggleNotes={() => toggleItemNotes(item.id)}
                    notesIcon={notesIcon}>
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
        <Button variant={'outline-primary'} className={'fw-bold pc-btn'} onClick={handleCustomerBack}>
          Back
        </Button>
        <Button variant={'outline-primary'} className={'fw-bold pc-btn pc-btn-download'}
                onClick={handleFileDownload} disabled={isSelectedOptionsEmpty}>
          Download
        </Button>
      </section>

      <DeleteItemModal
        show={isShowDeleteModal}
        onHide={handleCancelDeleteCategory}
        onConfirmDelete={handleConfirmDelete}
      />
      <ResetQuoteAlertModal />
      <CancelQuoteAlertModal />
    </Container>
  )
}
