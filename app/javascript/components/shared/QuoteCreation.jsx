import React from 'react'
import { Button } from 'react-bootstrap'
import { MultiStepProgressBar } from './MultiStepProgressBar'

export const QuoteCreation = ({ onClick, currentStepId, isBtnShow = true }) => {
  const ResetButton = () => (
    <Button variant={'outline-primary'} className={'pc-btn pc-btn-reset text-lato'} onClick={onClick}>
      Reset
    </Button>
  )

  return (
    <div className={'mb-8'}>
      <div className={'d-flex justify-content-between align-items-center mb-8'}>
        <h1 className={'lh-1'}>Quote Creation</h1>
        {isBtnShow && <ResetButton />}
      </div>
      <MultiStepProgressBar currentStepId={currentStepId} />
    </div>
  )
}
