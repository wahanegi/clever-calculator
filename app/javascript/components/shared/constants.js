export const ROUTES = {
  HOME: '/',
  CUSTOMER_INFO: '/customer-info',
  ITEM_PRICING: '/items-pricing',
  NOT_FOUND: '*',
  LOGIN: '/users/sign_in',
}

export const ENDPOINTS = {
  QUOTES: '/api/v1/quotes',
  LOGOUT: '/users/sign_out',
}

export const STEPS = {
  ITEM_PRICING: 'items_pricing',
  CUSTOMER_INFO: 'customer_info',
  COMPLETED: 'completed',
}

// STEPS_DATA is for PcProgressBar component
export const STEPS_DATA = [
  // step_id must be a number
  { step_id: 1, step: ROUTES.CUSTOMER_INFO, title: 'Customer Information' },
  { step_id: 2, step: ROUTES.ITEM_PRICING, title: 'Items & Pricing' },
]

// Centralized storage for image assets
import arrowDownUrl from '../../../assets/images/icons/arrow-down.svg'
import arrowUpUrl from '../../../assets/images/icons/arrow-up.svg'
import collapseDisableUrl from '../../../assets/images/icons/collapse-disable.svg'
import collapseUrl from '../../../assets/images/icons/collapse.svg'
import expandDisableUrl from '../../../assets/images/icons/expand-disable.svg'
import expandUrl from '../../../assets/images/icons/expand.svg'
import logoUrl from '../../../assets/images/icons/logo.svg'
import logoutUrl from '../../../assets/images/icons/logout.svg'
import placeholderUrl from '../../../assets/images/icons/placeholder.svg'
import dropdownArrowDownUrl from '../../../assets/images/icons/arrow-down.svg'
import dropdownArrowUpUrl from '../../../assets/images/icons/arrow-up.svg'
import accordionArrowUpUrl from '../../../assets/images/icons/accordion-arrow-up.svg'
import accordionArrowDownUrl from '../../../assets/images/icons/accordion-arrow-down.svg'

export const IMAGE_ASSETS = {
  ICONS: {
    logo: logoUrl,
    logout: logoutUrl,
    placeholder: placeholderUrl,
    arrow_down: arrowDownUrl,
    arrow_up: arrowUpUrl,
    collapse_disable: collapseDisableUrl,
    expand_disable: expandDisableUrl,
    collapse: collapseUrl,
    expand: expandUrl,
    dropdownArrowDown: dropdownArrowDownUrl,
    dropdownArrowUp: dropdownArrowUpUrl,
    accordionArrowUp: accordionArrowUpUrl,
    accordionArrowDown: accordionArrowDownUrl,
  },
  // future asset files can be added here
}
