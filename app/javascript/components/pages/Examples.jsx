import React from 'react'
import { PcButton } from '../ui'
import { CiLogout } from 'react-icons/ci'

// TODO for testing typography/buttons and will be deleted later
export const Examples = () => {
  return (
    <div className="container p-4">
      <h1 className="mb-4">Heading 1</h1>
      <h2 className="p-3 rounded mb-5">Heading 2</h2>
      <p className="fw-bold fs-5 text-teal-dark mb-4">Bold 32px text in teal-dark.</p>
      <p className="fw-semibold text-gray mb-3">Semibold 16px text in gray (inherits body size).</p>
      <p className="fst-italic fw-normal text-red-light mb-3">Italic normal 16px text in red-light.</p>
      <p className="fw-bold fs-10 text-blue-light mb-3">Small bold 12px text in blue-light.</p>
      <p className="text-inter text-dark mb-4">Inter medium 14px text in dark.</p>
      <div className="bg-gray-light p-9 mt-7 rounded">
        <p className="fw-medium text-dark">Medium weight text with large padding (64px) and margin-top (40px).</p>
      </div>
      <button className="btn border border-teal-dark text-primary p-3 mt-6">Click Me (Custom Spacing)</button>
      <p className="fs-1 fw-bold text-dark">Text color dark</p>
      <p className="fs-1 fw-bold text-primary">Text color primary</p>
      <p className="fs-1 fw-bold text-secondary">Text color secondary</p>
      <p className="fs-1 fw-bold text-light">Text color light</p>
      <p className="fs-1 fw-bold text-teal-dark">Text color teal-dark</p>
      <p>default text</p>

      <h1>Buttons</h1>
      <PcButton variant={'primary'}>
        <CiLogout className={'pc-logout-sm pc-rotate-180'} size={'sm'} />
        primary
      </PcButton>
      <PcButton variant={'primary'} disabled={true}>
        <CiLogout className={'pc-logout-sm pc-rotate-180'} size={'sm'} />
        primary disabled
      </PcButton>
      <PcButton variant={'primary warning'}>
        primary warning
        <CiLogout className={'pc-logout-sm pc-rotate-180'} size={'sm'} />
      </PcButton>
      <PcButton variant={'primary warning'} disabled={true}>
        <CiLogout className={'pc-logout-sm pc-rotate-180'} size={'sm'} />
        primary warning disabled
      </PcButton>

      <PcButton variant={'outline-primary'}>
        <CiLogout className={'pc-logout-sm pc-rotate-180'} size={'sm'} />
        outline-primary
      </PcButton>
      <PcButton variant={'outline-primary'} disabled={true}>
        <CiLogout className={'pc-logout-sm pc-rotate-180'} size={'sm'} />
        outline-primary disabled
      </PcButton>
      <PcButton variant={'outline-primary warning'}>
        <CiLogout className={'pc-logout-sm pc-rotate-180'} size={'sm'} />
        outline-primary warning
      </PcButton>
      <PcButton variant={'outline-primary warning'} disabled={true}>
        <CiLogout className={'pc-logout-sm pc-rotate-180'} size={'sm'} />
        outline-primary disabled
      </PcButton>
    </div>
  )
}
