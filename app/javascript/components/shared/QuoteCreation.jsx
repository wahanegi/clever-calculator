import React from 'react'
import { PcButton } from '../ui';
import { TITLES } from './constants';
import { PcMultiStepProgressBar } from './PcMultiStepProgressBar';

export const QuoteCreation = ({ onClick, currentStepId, isBtnShow = true }) => {
  return (
    <section className={'px-6 mb-2'}>
      <div className={'d-flex justify-content-between mb-6'}>
        <h1>{TITLES.MAIN}</h1>
        {isBtnShow &&
          <PcButton variant={'outline-primary'} children={'Reset'} className={'pc-btn-reset'} onClick={onClick} />
        }
      </div>
      <PcMultiStepProgressBar currentStepId={currentStepId} />
    </section>
  )
}
