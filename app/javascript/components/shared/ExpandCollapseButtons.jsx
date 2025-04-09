import React from 'react'
import { Button } from 'react-bootstrap'
import { PcIcon } from '../ui'

export const ExpandCollapseButtons = ({ onExpand, onCollapse, disableExpand, disableCollapse }) => {

  return (
    <div className={'d-flex gap-2'}>
      {/* Button Expand Розгорнути */}
      <Button
        variant={'outline'}
        className={'p-0 border-0 rounded-5 overflow-hidden'}
        disabled={disableExpand}
        onClick={onExpand}>
        <PcIcon name={`${disableExpand ? 'expand_disable' : 'expand'}`} />
      </Button>

      {/* Button Collapse */}
      <Button
        variant={'outline'}
        className={'p-0 border-0 rounded-5 overflow-hidden'}
        disabled={disableCollapse}
        onClick={onCollapse}>
        <PcIcon name={`${disableCollapse ? 'collapse_disable' : 'collapse'}`} />
      </Button>
    </div>
  )
}
