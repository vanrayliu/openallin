# Design Review Checklist

> UI/UX design review checklist for consistency, accessibility, and user-friendliness.

---

## UI Consistency

### Color Palette

- [ ] Primary color used consistently
- [ ] Secondary color used consistently
- [ ] Success color (green) for positive actions
- [ ] Warning color (yellow/orange) for caution
- [ ] Error color (red) for errors
- [ ] Neutral colors (gray scale) for backgrounds
- [ ] No more than 3-5 primary colors

**Common Issues**:
```css
/* Bad: Too many colors */
.primary { color: #007BFF; }
.secondary { color: #6C757D; }
.accent { color: #FF5733; }
.highlight { color: #FFC300; }
.brand { color: #900C3F; }

/* Good: Consistent palette */
.primary { color: #007BFF; }
.secondary { color: #6C757D; }
.success { color: #28A745; }
.warning { color: #FFC107; }
.error { color: #DC3545; }
```

---

### Typography

- [ ] Font family consistent across all pages
- [ ] Font sizes follow type scale (e.g., 12, 14, 16, 20, 24, 32, 48)
- [ ] Font weights used consistently (regular, medium, bold)
- [ ] Line heights consistent (1.5 for body, 1.2 for headings)
- [ ] Letter spacing consistent
- [ ] Text alignment consistent

**Type Scale Example**:
```css
/* Good: Consistent type scale */
.h1 { font-size: 48px; line-height: 1.1; }
.h2 { font-size: 32px; line-height: 1.2; }
.h3 { font-size: 24px; line-height: 1.3; }
.h4 { font-size: 20px; line-height: 1.3; }
.body { font-size: 16px; line-height: 1.5; }
.small { font-size: 14px; line-height: 1.5; }
.tiny { font-size: 12px; line-height: 1.5; }
```

---

### Spacing

- [ ] Consistent spacing scale (e.g., 4, 8, 12, 16, 24, 32, 48)
- [ ] Margins consistent between sections
- [ ] Paddings consistent within components
- [ ] Gaps consistent between elements
- [ ] No random spacing values

**Spacing Scale Example**:
```css
/* Good: Consistent spacing scale */
.space-xs { margin: 4px; }
.space-sm { margin: 8px; }
.space-md { margin: 16px; }
.space-lg { margin: 24px; }
.space-xl { margin: 32px; }
.space-2xl { margin: 48px; }
```

---

### Component Styles

#### Buttons

- [ ] Primary button style consistent
- [ ] Secondary button style consistent
- [ ] Disabled button style clear
- [ ] Hover state visible
- [ ] Active state visible
- [ ] Focus state visible
- [ ] Button sizes consistent (small, medium, large)
- [ ] Button icons aligned properly

**Button Checklist**:
```css
/* Button states */
.button-primary { background: #007BFF; color: white; }
.button-primary:hover { background: #0056B3; }
.button-primary:active { background: #004085; }
.button-primary:focus { outline: 2px solid #007BFF; }
.button-primary:disabled { opacity: 0.5; cursor: not-allowed; }
```

---

#### Inputs

- [ ] Text input style consistent
- [ ] Select style consistent
- [ ] Checkbox style consistent
- [ ] Radio button style consistent
- [ ] Error state clear
- [ ] Disabled state clear
- [ ] Focus state visible
- [ ] Placeholder text visible

**Input Checklist**:
```css
/* Input states */
.input { border: 1px solid #CED4DA; padding: 8px 12px; }
.input:focus { border-color: #007BFF; outline: none; }
.input:disabled { background: #E9ECEF; cursor: not-allowed; }
.input.error { border-color: #DC3545; }
```

---

#### Cards

- [ ] Card shadow consistent
- [ ] Card border consistent
- [ ] Card padding consistent
- [ ] Card border radius consistent
- [ ] Card hover state (if applicable)

---

### Visual Hierarchy

- [ ] Most important element is most prominent
- [ ] Size hierarchy clear (larger = more important)
- [ ] Color hierarchy clear (brighter = more important)
- [ ] Position hierarchy clear (top-left = more important)
- [ ] Spacing hierarchy clear (more space = more important)

---

## UX Best Practices

### Navigation

- [ ] Navigation visible on all pages
- [ ] Current page highlighted
- [ ] Navigation order logical
- [ ] Navigation accessible (keyboard)
- [ ] Mobile navigation works

**Navigation Checklist**:
- Logo links to home
- Main nav items <= 7
- Dropdown menus work
- Search accessible
- Breadcrumbs present (if deep hierarchy)

---

### Forms

- [ ] Labels above inputs (or left-aligned)
- [ ] Required fields marked
- [ ] Validation happens on blur (not while typing)
- [ ] Error messages specific and helpful
- [ ] Success feedback provided
- [ ] Submit button disabled during submission
- [ ] Form can be submitted with Enter key

**Form Validation Example**:
```javascript
// Good: Clear error messages
if (!email) {
  showError('Email is required');
} else if (!isValidEmail(email)) {
  showError('Please enter a valid email address');
}

// Bad: Vague error messages
if (!email || !isValidEmail(email)) {
  showError('Invalid input');
}
```

---

### Feedback

- [ ] Loading states for async operations
- [ ] Success messages for completed actions
- [ ] Error messages for failed actions
- [ ] Confirmation dialogs for destructive actions
- [ ] Undo option for reversible actions

**Loading States**:
```javascript
// Good: Clear loading state
<Button disabled={isLoading}>
  {isLoading ? <Spinner /> : 'Submit'}
</Button>
```

---

### Empty States

- [ ] Empty list has helpful message
- [ ] Empty search results have suggestions
- [ ] Empty dashboard has getting started guide
- [ ] Empty error has retry button

**Empty State Example**:
```jsx
// Good: Helpful empty state
<EmptyState
  icon={<InboxIcon />}
  title="No messages yet"
  description="When you receive messages, they'll appear here."
  action={<Button>Send a message</Button>}
/>
```

---

## Accessibility (WCAG 2.1)

### Color Contrast

- [ ] Normal text: contrast ratio >= 4.5:1
- [ ] Large text (18pt+): contrast ratio >= 3:1
- [ ] UI components: contrast ratio >= 3:1

**Contrast Checker**:
```bash
# Check contrast ratio
npm install -g color-contrast
color-contrast "#FFFFFF" "#FF6B6B"
# Output: 3.2:1 (FAIL - needs >= 4.5:1)
```

**Common Issues**:
```css
/* Bad: Low contrast */
.text-muted { color: #999999; background: white; } /* 2.8:1 */

/* Good: Sufficient contrast */
.text-muted { color: #6C757D; background: white; } /* 4.6:1 */
```

---

### Keyboard Navigation

- [ ] All interactive elements focusable
- [ ] Tab order logical
- [ ] Focus state visible
- [ ] No keyboard traps
- [ ] Enter/Space activate buttons
- [ ] Escape closes modals

**Focus State**:
```css
/* Good: Visible focus state */
*:focus {
  outline: 2px solid #007BFF;
  outline-offset: 2px;
}

/* Bad: No focus state */
*:focus {
  outline: none;
}
```

---

### Screen Reader Support

- [ ] All images have alt text
- [ ] Decorative images have empty alt=""
- [ ] All inputs have labels
- [ ] Form errors announced
- [ ] Dynamic content announced (aria-live)
- [ ] Links have descriptive text (not "click here")

**Alt Text Examples**:
```html
<!-- Good: Descriptive alt text -->
<img src="chart.png" alt="Sales increased 25% from Q1 to Q2">

<!-- Good: Empty alt for decorative images -->
<img src="divider.png" alt="">

<!-- Bad: Generic alt text -->
<img src="chart.png" alt="chart">
```

---

### ARIA Attributes

- [ ] aria-label for elements without visible text
- [ ] aria-labelledby for elements with visible label
- [ ] aria-describedby for additional context
- [ ] aria-expanded for expandable elements
- [ ] aria-hidden for decorative elements
- [ ] role attribute used correctly

**ARIA Examples**:
```html
<!-- Button with icon only -->
<button aria-label="Close dialog">
  <XIcon />
</button>

<!-- Expandable menu -->
<button aria-expanded="false" aria-controls="menu">
  Menu
</button>

<!-- Live region for notifications -->
<div aria-live="polite" aria-atomic="true">
  Item added to cart
</div>
```

---

## Responsive Design

### Breakpoints

- [ ] Desktop: 1280px and above
- [ ] Laptop: 1024px - 1279px
- [ ] Tablet: 768px - 1023px
- [ ] Mobile large: 414px - 767px
- [ ] Mobile small: 320px - 413px

**Breakpoint Setup**:
```css
/* Mobile-first approach */
@media (min-width: 768px) { /* tablet */ }
@media (min-width: 1024px) { /* laptop */ }
@media (min-width: 1280px) { /* desktop */ }
```

---

### Mobile Optimization

- [ ] Touch targets >= 44x44px
- [ ] No horizontal scroll
- [ ] Text readable without zoom (16px minimum)
- [ ] Buttons full-width or large enough
- [ ] Forms use appropriate input types (email, tel, number)
- [ ] No hover-only interactions

**Touch Targets**:
```css
/* Good: Large touch targets */
.button {
  min-height: 44px;
  min-width: 44px;
  padding: 12px 16px;
}

/* Bad: Small touch targets */
.button {
  padding: 4px 8px;
}
```

---

### Adaptive Content

- [ ] Images scale properly
- [ ] Tables scroll horizontally on mobile
- [ ] Navigation collapses to hamburger menu
- [ ] Sidebars move to bottom or hide on mobile
- [ ] Font sizes adjust appropriately

---

## Visual Polish

### Layout

- [ ] No content overflow
- [ ] No horizontal scroll (except intentional)
- [ ] No broken layouts on different screen sizes
- [ ] Grid system consistent
- [ ] Flexbox/Grid used appropriately

---

### Animations

- [ ] Transitions smooth (not jarring)
- [ ] Animations purposeful (not decorative)
- [ ] Animations respect prefers-reduced-motion
- [ ] Animation duration appropriate (200-500ms)

**Animation Best Practices**:
```css
/* Good: Smooth transition with reduced motion support */
.card {
  transition: transform 300ms ease;
}

@media (prefers-reduced-motion: reduce) {
  .card {
    transition: none;
  }
}
```

---

### Images

- [ ] Images optimized (compressed)
- [ ] Lazy loading for below-fold images
- [ ] Responsive images (srcset)
- [ ] Aspect ratio preserved
- [ ] Placeholder shown while loading

**Image Optimization**:
```html
<!-- Good: Responsive image with lazy loading -->
<img
  src="image-800.jpg"
  srcset="image-400.jpg 400w, image-800.jpg 800w, image-1200.jpg 1200w"
  sizes="(max-width: 600px) 100vw, 50vw"
  loading="lazy"
  alt="Product photo"
/>
```

---

## Design Review Tools

### Automated Tools

```bash
# Accessibility testing
npm install -D @axe-core/react

# Visual regression testing
npm install -D @playwright/test

# Color contrast checking
npm install -D color-contrast

# Performance testing
npm install -D lighthouse
```

---

### Manual Testing

1. **Visual Testing**: Check all pages visually
2. **Accessibility Testing**: Use screen reader
3. **Keyboard Testing**: Tab through all elements
4. **Mobile Testing**: Test on real devices
5. **Browser Testing**: Test in Chrome, Firefox, Safari

---

## Design Review Checklist Summary

| Category | Items | Critical Level |
|----------|-------|----------------|
| UI Consistency | Color, Typography, Spacing, Components | Medium |
| UX Best Practices | Navigation, Forms, Feedback, Empty States | Medium |
| Accessibility | Color Contrast, Keyboard, Screen Reader | High |
| Responsive Design | Breakpoints, Mobile, Adaptive Content | High |
| Visual Polish | Layout, Animations, Images | Low |

---

## Common Design Issues

| Issue | Severity | Fix |
|-------|----------|-----|
| Low color contrast | High | Darken text or lighten background |
| Missing focus states | High | Add visible focus outline |
| Small touch targets | Medium | Increase padding to 44x44px minimum |
| No empty states | Medium | Add helpful messages and CTAs |
| Inconsistent spacing | Low | Use spacing scale (4, 8, 12, 16...) |
| No loading states | Medium | Add spinner or skeleton |
| Horizontal scroll on mobile | High | Fix layout overflow |
| No alt text | High | Add descriptive alt text |

---

## Notes

- Design review is **not a replacement** for professional UX review
- Use as pre-merge check, not final gate
- Combine with user testing for best results
- Run `/oa-qa-browser` for automated accessibility tests
- Test with real users whenever possible