import React from 'react'
import { Button } from 'react-bootstrap'
import { MultiStepProgressBar } from './MultiStepProgressBar'

export const QuoteCreation = ({ onClick, currentStepId, isBtnShow = true }) => {
  const ResetButton = () =>
    <Button variant={'outline-primary'}
            className={'pc-btn-reset fw-medium'}
            onClick={onClick}>
      Reset
    </Button>

  return (
    <section className={'px-6 mb-2'}>
      <div className={'d-flex justify-content-between align-items-center mb-6'}>
        <h1>Quote Creation</h1>
        {isBtnShow && <ResetButton />}
      </div>
      <MultiStepProgressBar currentStepId={currentStepId} />
    </section>
  )
}
