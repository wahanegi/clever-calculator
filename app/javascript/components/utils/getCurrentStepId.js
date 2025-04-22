import { STEPS_DATA } from '../shared';

export const getCurrentStepId = (pathname) => {
  return STEPS_DATA.find((item) => item.step === pathname)?.step_id
}
