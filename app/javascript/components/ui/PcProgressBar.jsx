import React from 'react'

export const PcProgressBar = ({ currentStepId = 1, totalSteps = 2 }) => {
  const progressPercentage = (currentStepId / totalSteps) * 100

  return (
    <div className={'position-relative d-flex justify-content-center align-items-center'} style={{ height: '12px' }}>
      {/* track */}
      <div className={'w-100 h-50 rounded-5 bg-blue-light'}></div>

      {/* thumb */}
      <div
        className={`position-absolute top-50 start-0 translate-middle-y h-100 rounded-5 bg-primary`}
        style={{ width: `${progressPercentage}%` }}
      >
      </div>
    </div>
  )
}
