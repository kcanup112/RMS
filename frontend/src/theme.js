import { createTheme } from '@mui/material/styles'

const theme = createTheme({
  palette: {
    primary: {
      main: '#667eea',
      light: '#8b9cff',
      dark: '#4c63d2',
      contrastText: '#fff',
    },
    secondary: {
      main: '#764ba2',
      light: '#a377d4',
      dark: '#4e2e71',
      contrastText: '#fff',
    },
    success: {
      main: '#43e97b',
      light: '#6bffa0',
      dark: '#2bb656',
    },
    error: {
      main: '#f5576c',
      light: '#ff7e8d',
      dark: '#d0304a',
    },
    warning: {
      main: '#fa709a',
      light: '#ff9ec3',
      dark: '#c54771',
    },
    info: {
      main: '#4facfe',
      light: '#78c4ff',
      dark: '#2985d6',
    },
    background: {
      default: '#f5f7fa',
      paper: '#ffffff',
    },
  },
  typography: {
    fontFamily: '"Inter", "Roboto", "Helvetica", "Arial", sans-serif',
    h1: {
      fontWeight: 700,
    },
    h2: {
      fontWeight: 700,
    },
    h3: {
      fontWeight: 700,
    },
    h4: {
      fontWeight: 600,
    },
    h5: {
      fontWeight: 600,
    },
    h6: {
      fontWeight: 600,
    },
    button: {
      textTransform: 'none',
      fontWeight: 600,
    },
  },
  shape: {
    borderRadius: 8,
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: 8,
          padding: '8px 20px',
          fontSize: '0.95rem',
          boxShadow: 'none',
          '&:hover': {
            boxShadow: '0 4px 8px rgba(0,0,0,0.1)',
          },
        },
        contained: {
          boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          backgroundImage: 'none',
        },
        elevation1: {
          boxShadow: '0 1px 3px rgba(0,0,0,0.08)',
        },
        elevation2: {
          boxShadow: '0 2px 6px rgba(0,0,0,0.1)',
        },
        elevation3: {
          boxShadow: '0 4px 12px rgba(0,0,0,0.12)',
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          borderRadius: 12,
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          '& .MuiOutlinedInput-root': {
            borderRadius: 8,
          },
        },
      },
    },
    MuiTableCell: {
      styleOverrides: {
        root: {
          borderColor: '#e0e7ff',
        },
        head: {
          fontWeight: 600,
        },
      },
    },
  },
})

export default theme
