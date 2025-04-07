import React from 'react'
import { ExpandCollapseButtons } from './ExpandCollapseButtons'
import { MultiSelectDropdown } from './MultiSelectDropdown'

export const ItemsPricingTopBar = ({ totalPrice, isExpended, handleToggle }) => {
  // const [isExpended, setIsExpended] = useState(false)
  //
  // const handleToggle = () => {
  //   setIsExpended((prev) => !prev)
  //   // TODO: add logic for accordion
  // }

  return (
    <div className="d-grid align-items-center mb-8 px-6"
         style={{
           gridTemplateColumns: 'minmax(0, 512px) auto auto',
           columnGap: '20px',
         }}>

      {/* Dropdown for selecting items*/}
      <MultiSelectDropdown />

      {/* Expand/Collapse buttons */}
      <ExpandCollapseButtons isExpended={isExpended} onClick={handleToggle} />

      {/* Total price */}
      <div className={'d-flex flex-column align-items-end'}>
        <div className={'d-flex gap-2 align-items-center'}>
          <hr className={'pc-hr-divider'} />
          <span className={'fs-10 text-secondary'}>Total price</span>
        </div>
        <span className={'fs-10 pc-fw-900'}>$&nbsp;{totalPrice}</span>
      </div>
    </div>
  )
}
