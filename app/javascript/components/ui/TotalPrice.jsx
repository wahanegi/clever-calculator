import React from 'react'
import { formatCurrency } from '../utils'
export const TotalPrice = ({ totalPrice }) => (
  <div className={'d-flex flex-column align-items-end'}>
    <div className={'d-flex gap-2 align-items-center'}>
      <hr className={'pc-hr-divider'} />
      <span className={'fs-10 text-secondary'}>Total price</span>
    </div>
    <span className={'fs-10 pc-fw-900'}>{formatCurrency(totalPrice)}</span>
  </div>
)
