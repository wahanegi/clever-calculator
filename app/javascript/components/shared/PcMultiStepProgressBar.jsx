import React from 'react'
import { PcProgressBar, PcStepIndicator } from '../ui';
import { STEPS_DATA } from './constants';

export const PcMultiStepProgressBar = ({ currentStepId }) => {
  const totalSteps = STEPS_DATA?.length
  const currentTitle = STEPS_DATA.find(item => item.step_id === currentStepId)?.title

  return (
    <div>
      {/* Steps title a top of progress bar*/}
      <div className={'d-flex justify-content-around align-items-center mb-3'}>
        {STEPS_DATA.map(({ step_id, title }) => (
          <p key={step_id} className={`text-inter ${step_id <= currentStepId ? 'text-primary' : 'text-gray-light'}`}>
            {title}
          </p>
        ))}
      </div>

      {/* Progress bar */}
      <div className={'mb-4'}>
        <PcProgressBar currentStepId={currentStepId} totalSteps={totalSteps} />
      </div>

      {/*  Steps indicator */}
      <div className={'d-flex justify-content-end mb-2'}>
        <PcStepIndicator currentStepId={currentStepId} totalSteps={totalSteps} />
      </div>

      {/* Steps title */}
      <h2 className={'text-center'}>{currentTitle}</h2>
    </div>
  )
}
