import React from 'react'
import { Button } from 'react-bootstrap'
import { MultiStepProgressBar } from './MultiStepProgressBar'

export const QuoteCreation = ({
                                onReset,
                                currentStepId,
                                isBtnShow = true,
                                disabledResetButton,
                              }) => {
  const ResetButton = () => (
    <Button variant={'outline-primary'} className={'pc-btn pc-btn-reset text-lato'}
            onClick={onReset} disabled={disabledResetButton}>
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
