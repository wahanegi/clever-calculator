import React from 'react'
import { Button } from 'react-bootstrap'

export const QuoteCreation = ({ handleClick, currentStep }) => {
  return (<section className={'d-flex justify-content-between mb-6 align-items-center px-6 mb-2'}>
    <h1>Quote Creation</h1>
    <Button variant={'outline-primary'}
            className={'pc-reset-button rounded-3'}
            onClick={handleClick}>Reset</Button>
  </section>)
}