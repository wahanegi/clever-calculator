import React from "react"
import DatePicker from "react-datepicker"
import { PcItemFormGroup } from "../ui"
import { PcItemSelectControl } from "../ui"
import { useEffect, useState } from "react"
import { fetchContractTypes } from "../services"

const ContractTypeAndPeriod = ({ onUpdateContractType, onUpdateContractPeriod, quote }) => {
    const [contractTypes, setContractTypes] = useState([])
    const [contractStartDate, setContractStartDate] = useState(null)
    const [contractEndDate, setContractEndDate] = useState(null)

    useEffect(() => {
        fetchContractTypes.index()
            .then((contractTypes) => {
                const contractTypesMap = contractTypes.data.map((contractType) =>
                ({
                    value: contractType.id,
                    label: contractType.attributes.name
                }))

                setContractTypes(contractTypesMap)
            })
    }, [])

    useEffect(() => {
        if (quote?.attributes?.contract_start_date && quote?.attributes?.contract_end_date) {
            setContractStartDate(new Date(quote?.attributes?.contract_start_date))
            setContractEndDate(new Date(quote?.attributes?.contract_end_date))
        }
    }, [quote])

    const handleChangeContractPeriod = (updatedDates) => {
        const [startDate, endDate] = updatedDates

        setContractStartDate(startDate)
        setContractEndDate(endDate)
    }

    const handleBlurContractPeriod = () => {
        if (contractStartDate && contractEndDate) {
            const formatedStartDate = contractStartDate.toLocaleDateString()
            const formatedEndDate = contractEndDate.toLocaleDateString()

            onUpdateContractPeriod(formatedStartDate, formatedEndDate)
        }
    }

    return (
        <div className='d-flex gap-4 mb-2'>
            <PcItemFormGroup label={'Contract Type'} paramType="selectable-param">
                <PcItemSelectControl
                    options={contractTypes}
                    value={quote?.attributes?.contract_type_id}
                    onChange={onUpdateContractType}
                />
            </PcItemFormGroup>

            <PcItemFormGroup label={'Terms of subscription & service:'} paramType="contract-period">
                <DatePicker
                    className="fs-10 pc-lh-xl form-control"
                    selectsRange={true}
                    startDate={contractStartDate}
                    endDate={contractEndDate}
                    onChange={handleChangeContractPeriod}
                    onBlur={handleBlurContractPeriod}
                    isClearable={true}
                />
            </PcItemFormGroup>
        </div>
    )
}

export default ContractTypeAndPeriod