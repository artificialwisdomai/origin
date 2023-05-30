/** @type {import('tailwindcss').Config} */
/** @type {import('tailwindcss').Config} */



// this function handles the opacity of color
function withOpacityValue(variable) {
  return ({ opacityValue }) => {
    if (opacityValue === undefined) {
      return `hsl(var(${variable}))`
    }
    return `hsl(var(${variable}) / ${opacityValue})`
  }
}


module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}', // Note the addition of the `app` directory.
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],

  theme: {
    extend: {
      colors: {
        'primary-light': withOpacityValue('--primary-light'),
        'primary-dark': withOpacityValue('--primary-dark'),
        'primary-darker': withOpacityValue('--primary-darker'),

        'secondary-light': withOpacityValue('--secondary-light'),
        'secondary-dark': withOpacityValue('--secondary-dark'),
        'secondary-darker': withOpacityValue('--secondary-darker'),

        'secondary-a': withOpacityValue('--secondary-a'),
        'secondary-b': withOpacityValue('--secondary-b'),
        'secondary-c': withOpacityValue('--secondary-c'),
        'secondary-d': withOpacityValue('--secondary-d'),

        'neutral-light': withOpacityValue('--neutral-light'),
        'neutral-dark': withOpacityValue('--neutral-dark'),


        
          // Teals
          'teal': {
            light: '#9ee0d9',
            DEFAULT: '#038E7D',
            dark: '#1b666a',
            darker: '#163e41',
          },
        
            // Oranges
          'orange': {
            light: '#f79e4a',
            DEFAULT: '#EE792F',
            dark: '#f35512',
            darker: '#e03c06',
          },
        
            // Neutrals
          'white': '#ffffff',
          'gray': {
            light: '#585f5f',
            DEFAULT: '#373e3e',
            dark: '#090b0b',
          },
          'black': '#000000',
        },
    },
  },

  plugins: [
    require('tailwind-scrollbar'),
    require("daisyui")
  ],

  daisyui: {
    themes: [
      {
        awlight: {
          ...require('daisyui/src/colors/themes')['[data-theme=awlight]'],
          
          '--primary-light': '174 51% 75%',
          '--primary-dark': '183 59% 26%',
          '--primary-darker': '184 49% 17%',

          primary: "#038E7D",
          'primary-content': '#9ee0d9',
          'primary-focus': '#0d9488',

          secondary: '#EE792F',
          'secondary-focus': '#f79e4a',
          'secondary-content': '#96370f',

          '--secondary-light': '29 92% 63%',
          '--secondary-dark': '18 90% 51%',
          '--secondary-darker': '13 95% 23%',

          accent: "#000000",
          neutral: "#373e3e",

          '--neutral-light': '180 4% 36%',
          '--neutral-dark': '180 10% 4%',

          "base-100": "#ffffff",
        },

        awdark: {
          ...require('daisyui/src/colors/themes')['[data-theme=awdark]'],
          
          primary: "#038E7D",
          'primary-content': '#9ee0d9',
          'primary-focus': '#0d9488',

          '--primary-light': '174 51% 75%',
          '--primary-dark': '183 59% 26%',
          '--primary-darker': '184 49% 17%',

          secondary: '#EE792F',
          'secondary-focus': '#f79e4a',
          'secondary-content': '#96370f',
          
          '--secondary-light': '29 92% 63%',
          '--secondary-dark': '18 90% 51%',
          '--secondary-darker': '13 95% 23%',

          accent: "#ffffff",
          neutral: "#373e3e",

          '--neutral-light': '180 4% 36%',
          '--neutral-dark': '180 10% 4%',
          
          "base-100": "#090b0b",
        },
      },
    ],
  },
  
};
