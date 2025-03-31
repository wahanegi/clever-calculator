import React from 'react';

export const PcStepIndicator = ({ currentStepId, totalSteps }) => {
  return (
    <div>
      <span className="text-inter text-primary fw-bold">Step {currentStepId}&nbsp;</span>
      <span className="text-inter text-secondary">of {totalSteps}</span>
    </div>
  );
};
