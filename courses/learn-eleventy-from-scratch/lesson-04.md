# Lesson 4 - Front matter basics

## Adding Front Matter to our home page

Add this to your `index.md` (right below the `layout` line):
```yaml
intro:
  eyebrow: 'Digital Marketing is our'
  main: 'Bread & Butter'
  summary: 'Let us help you create the perfect campaign with our multi-faceted team of talented creatives.'
  buttonText: 'See our work'
  buttonUrl: '/work'
  image: '/images/bg/toast.jpg'
  imageAlt: 'Buttered toasted white bread'
```

And then open `src/_includes/layouts/home.html` and replace the existing `<article>` with this:

```html
<article class="intro">
  <div class="[ intro__header ] [ radius frame ]">
    <h1 class="[ intro__heading ] [ weight-normal text-400 md:text-600 ]">
      {{ intro.eyebrow }}
      <em class="text-800 md:text-900 lg:text-major weight-bold">{{ intro.main }}</em>
    </h1>
  </div>
  <div class="[ intro__content ] [ flow ]">
    <p class="intro__summary">{{ intro.summary }}</p>
    <a href="{{ intro.buttonUrl }}" class="button">{{ intro.buttonText }}</a>
  </div>
  <div class="[ intro__media ] [ radius dot-shadow ]">
    <img
      class="[ intro__image ] [ radius ]"
      src="{{ intro.image }}"
      alt="{{ intro.imageAlt }}"
    />
  </div>
</article>
```







