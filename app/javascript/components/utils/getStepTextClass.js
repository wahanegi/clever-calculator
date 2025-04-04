export const getStepTextClass = (step_id, currentStepId) => {
  if (step_id < currentStepId) return 'text-dark'
  if (step_id === currentStepId) return 'text-primary'
  return 'text-gray-light'
}
