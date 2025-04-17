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
  CUSTOMERS: '/api/v1/customers',
  CUSTOMERS_UPSERT: '/api/v1/customers/upsert',
  CATEGORIES: '/api/v1/categories',
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
import accordionArrowDownUrl from '../../../assets/images/icons/accordion-arrow-down.svg'
import accordionArrowUpUrl from '../../../assets/images/icons/accordion-arrow-up.svg'
import arrowDownUrl from '../../../assets/images/icons/arrow-down.svg'
import arrowUpUrl from '../../../assets/images/icons/arrow-up.svg'
import disableCollapseUrl from '../../../assets/images/icons/collapse-disable.svg'
import collapseUrl from '../../../assets/images/icons/collapse.svg'
import disableExpandUrl from '../../../assets/images/icons/expand-disable.svg'
import expandUrl from '../../../assets/images/icons/expand.svg'
import logoUrl from '../../../assets/images/icons/logo.svg'
import logoutUrl from '../../../assets/images/icons/logout.svg'
import noteUrl from '../../../assets/images/icons/note.svg'
import notedUrl from '../../../assets/images/icons/noted.svg'
import placeholderUrl from '../../../assets/images/icons/placeholder.svg'
import trashDangerUrl from '../../../assets/images/icons/trash-danger.svg'
import trashTwoUrl from '../../../assets/images/icons/trash-default.svg'
import trashDefaultUrl from '../../../assets/images/icons/trash-default.svg'
import trashUrl from '../../../assets/images/icons/trash.svg'

export const IMAGE_ASSETS = {
  ICONS: {
    logo: logoUrl,
    logout: logoutUrl,
    placeholder: placeholderUrl,
    arrowDown: arrowDownUrl,
    arrowUp: arrowUpUrl,
    disableCollapse: disableCollapseUrl,
    disableExpand: disableExpandUrl,
    collapse: collapseUrl,
    expand: expandUrl,
    accordionArrowUp: accordionArrowUpUrl,
    accordionArrowDown: accordionArrowDownUrl,
    note: noteUrl,
    noted: notedUrl,
    trash: trashUrl,
    trashTwo: trashTwoUrl,
    trashDefault: trashDefaultUrl,
    trashDanger: trashDangerUrl,
  },
  // future asset files can be added here
}
