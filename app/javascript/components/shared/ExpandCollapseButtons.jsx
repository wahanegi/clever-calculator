import React from 'react'
import { Button } from 'react-bootstrap'
import { PcIcon } from '../ui'

export const ExpandCollapseButtons = ({ isExpended, onClick }) => {
  return (
    <div className={'d-flex gap-2'}>
      <Button className={'p-0 border-0 rounded-5 overflow-hidden'} disabled={isExpended}
              onClick={onClick}>
        <PcIcon name={`${isExpended ? 'expand_disable' : 'expand'}`} />
      </Button>
      <Button variant={'outline'} className={'p-0 border-0 rounded-5 overflow-hidden'} disabled={!isExpended}
              onClick={onClick}>
        <PcIcon name={`${!isExpended ? 'collapse_disable' : 'collapse'}`} />
      </Button>
    </div>
  )
}
