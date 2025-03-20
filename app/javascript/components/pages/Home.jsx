import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { fetchQuotes } from '../services/fetchService'
import { ROUTES } from '../shared'
import { Navigate } from 'react-router-dom'

export const Home = () => {
  const navigate = useNavigate()
  const [redirectTo, setRedirectTo] = useState(null)

  useEffect(() => {
    const fetchLastQuote = async () => {
      try {
        const response = await fetchQuotes.last()
        const { data } = response.data

        if (data) {
          const {
            id: quoteId,
            attributes: { step },
          } = data
          if (step === 'items_pricing') {
            setRedirectTo(`${ROUTES.ITEM_PRICING}?quote_id=${quoteId}`)
          } else {
            setRedirectTo(ROUTES.CUSTOMER_INFO)
          }
        } else {
          setRedirectTo(ROUTES.CUSTOMER_INFO)
        }
      } catch (error) {
        console.error('Error fetching last quote:', error)
        setRedirectTo(ROUTES.CUSTOMER_INFO)
      }
    }
    fetchLastQuote()
  }, [navigate])

  if (!redirectTo) return <div>Loading...</div>
  return <Navigate to={redirectTo} replace />
}
