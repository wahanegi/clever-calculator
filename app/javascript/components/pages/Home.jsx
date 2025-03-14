import React from 'react'

export const Home = () => {
  return (
    // TODO for testing typography will be deleted later
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
    </div>
  )
}

export default Home
