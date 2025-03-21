import { useLocation, useNavigate, useParams } from 'react-router-dom'

export const useAppHooks = () => {
  const navigate = useNavigate()
  const location = useLocation()
  const params = useParams()
  const queryParams = new URLSearchParams(location.search)

  return { navigate, location, params, queryParams }
}
