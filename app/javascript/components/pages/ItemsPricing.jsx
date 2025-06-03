import React, { useState, useEffect, useRef } from 'react'
import { Button, Container, Form } from 'react-bootstrap'
import { useAppHooks } from '../hooks'
import { DeleteItemModal, ItemsPricingTopBar, Item, QuoteCreation, DownloadSuccessModal } from '../shared'
import {
  CancelQuoteAlertModal,
  OverLimitAlertModal,
  PcCategoryAccordion,
  PcItemAccordion,
  PcItemFormGroup,
} from '../ui'
import { getCurrentStepId, totalFinalPrice, triggerFileDownload } from '../utils'
import { fetchNotes, fetchQuoteItems, fetchQuotes, fetchSelectableOptions } from '../services'
import { AlertModal } from '../shared/AlertModal'
import debounce from 'lodash/debounce'

export const ItemsPricing = () => {
  const [isOverPriceLimit, setIsOverPriceLimit] = useState(false)
  const { queryParams, location } = useAppHooks()
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
  const [isShowSuccessfulDownloadModal, setIsShowSuccessfulDownloadModal] = useState(false)

  const isSelectedOptionsEmpty = selectedOptions.length === 0
  const totalPrice = selectedOptions.reduce((total, option) => total + parseFloat(totalFinalPrice(option?.quote_items || [])), 0).toFixed(2)


  useEffect(() => {
    fetchSelectableOptions.index().then((data) => {
      setSelectableOptions(data)
    })
    fetchQuoteItems.index(quoteId).then((data) => {
      setSelectedOptions(data)

      setExpandedAccordions(data.map((option) => option.id))

      const initialNotesStates = {}
      data.forEach((option) => {
        option.quote_items.forEach((item) => {
          const note = item.attributes?.note
          initialNotesStates[item.id] = {
            note: note?.notes || '',
            include: note?.is_printable || false,
            isNotesOpen: false,
            tempNote: note?.notes || '',
          }
        })
      })
      setNotesStates(initialNotesStates)
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
      [itemId]: {
        ...(prev[itemId] || {}),
        tempNote: value,
      },
    }))
  }

  const handleNotesBlur = (itemId) => {
    const tempNote = notesStates[itemId]?.tempNote || ''
    const updatedNote = {
      ...(notesStates[itemId] || {}),
      note: tempNote,
    }
    setNotesStates((prev) => ({
      ...prev,
      [itemId]: updatedNote,
    }))
    debouncedUpdateNote(itemId, updatedNote)
  }

  const handleIncludeNotesChange = (itemId, checked) => {
    const updatedNote = {
      ...(notesStates[itemId] || {}),
      include: checked,
    }
    setNotesStates((prev) => ({
      ...prev,
      [itemId]: updatedNote,
    }))
    debouncedUpdateNote(itemId, updatedNote)
  }

  const updateNote = (itemId, noteData) => {
    const current = notesStates[itemId] || {}

    const trimmedNote = noteData?.note?.trim() || ''

    if (trimmedNote === '') {
      fetchNotes.destroy(quoteId, itemId).then(() => {
        setNotesStates((prev) => ({
          ...prev,
          [itemId]: {
            ...(prev[itemId] || {}),
            note: '',
            include: false,
            tempNote: '',
          },
        }))
      })
      return
    }

    const hasChanged =
      trimmedNote !== (current.note || '').trim() || (noteData.include || false) !== (current.include || false)

    if (!hasChanged) return

    const noteParameters = {
      note: {
        notes: trimmedNote,
        is_printable: noteData.include || false,
      },
    }

    fetchNotes.upsert(quoteId, itemId, noteParameters).then((updatedNoteData) => {
      const updatedAttributes = updatedNoteData?.data?.attributes
      if (!updatedAttributes) return

      const { notes, is_printable } = updatedAttributes

      setNotesStates((prev) => ({
        ...prev,
        [itemId]: {
          ...(prev[itemId] || {}),
          note: notes,
          include: is_printable,
          tempNote: notes,
        },
      }))
    })
  }

  const debouncedUpdateNote = useRef(
    debounce((itemId, data) => {
      updateNote(itemId, data)
    }, 200),
  ).current

  const toggleItemNotes = (itemId) => {
    setNotesStates((prev) => ({
      ...prev,
      [itemId]: { ...(prev[itemId] || {}), isNotesOpen: !prev[itemId]?.isNotesOpen },
    }))
  }

  const handleFileDownload = (e) => {
    e.target.blur()

    fetchQuotes.generateFile(quoteId)
      .then((blob) => {
        triggerFileDownload(blob, `quote_${quoteId}.docx`)

        setIsShowSuccessfulDownloadModal(true)
      }).catch((err) => {
      console.error('File download failed', err)
    })
  }

  const handleCustomerBack = (e) => {
    e.target.blur()

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

  const ResetQuoteAlertModal = () => {
    const handleCancel = () => {
      setIsShowResetQuoteAlertModal(false)
    }

    const handleConfirm = () => {
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
          setExpandedAccordions={setExpandedAccordions}
        />

        <EmptyQuotePrompt />
      </section>

      <section className={'d-flex flex-column gap-4 mb-12'}>
        {selectedOptions.map((selectedOption) =>
          <PcCategoryAccordion
            key={`${selectedOption.type}"-${selectedOption.id}`}
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
                          setSelectedOptions={setSelectedOptions}
                          setIsOverPriceLimit={setIsOverPriceLimit} />

                    {notesState.isNotesOpen && (
                      <PcItemFormGroup label={'Notes'} paramType={'notes'}>
                        <Form.Control
                          as="textarea"
                          style={{ height: '80px' }}
                          className={'mb-3 mt-9 py-2'}
                          value={notesState.tempNote || ''}
                          onChange={(e) => handleNotesChange(item.id, e.target.value)}
                          onBlur={() => handleNotesBlur(item.id)}
                        />
                        <Form.Group
                          className="form-check pc-item-input notes fs-10"
                        >
                          <Form.Check.Input
                            type="checkbox"
                            id={`include-notes-${item.id}`}
                            checked={notesState.include || false}
                            onChange={(e) => handleIncludeNotesChange(item.id, e.target.checked)}
                          />
                          <Form.Label htmlFor={`include-notes-${item.id}`} className="form-check-label">
                            Include notes with quote
                          </Form.Label>
                        </Form.Group>
                      </PcItemFormGroup>
                    )}
                  </PcItemAccordion>
                )
              })}
            </div>
          </PcCategoryAccordion>)}
      </section>

      <section className={'d-flex justify-content-center align-items-center gap-4 mb-4'}>
        <Button
          variant={'outline-primary'}
          className={'fw-bold pc-btn'}
          onClick={handleCustomerBack}
        >
          Back
        </Button>
        <Button
          variant={'primary'}
          className={'fw-bold pc-btn pc-btn-download'}
          onClick={handleFileDownload}
          disabled={isSelectedOptionsEmpty}
        >
          Download
        </Button>
      </section>

      <DownloadSuccessModal onHide={() => setIsShowSuccessfulDownloadModal(false)}
                            show={isShowSuccessfulDownloadModal} />
      <DeleteItemModal
        nameItem={removeSelectedOption?.name}
        show={isShowDeleteModal}
        onHide={handleCancelDeleteCategory}
        onConfirmDelete={handleConfirmDelete}
      />
      <ResetQuoteAlertModal />
      <CancelQuoteAlertModal isShowCancelQuoteAlertModal={isShowCancelQuoteAlertModal}
                             setIsShowCancelQuoteAlertModal={setIsShowCancelQuoteAlertModal} />
      <OverLimitAlertModal isOverPriceLimit={isOverPriceLimit} setIsOverPriceLimit={setIsOverPriceLimit} />
    </Container>
  )
}
