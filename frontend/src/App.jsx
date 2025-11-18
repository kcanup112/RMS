import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { ThemeProvider, createTheme } from '@mui/material/styles'
import CssBaseline from '@mui/material/CssBaseline'
import Layout from './components/Layout'
import Dashboard from './pages/Dashboard'
import Departments from './pages/Departments'
import Programmes from './pages/Programmes'
import Semesters from './pages/Semesters'
import Teachers from './pages/Teachers'
import Subjects from './pages/Subjects'
import Classes from './pages/Classes'
import Days from './pages/Days'
import Periods from './pages/Periods'
import Schedules from './pages/Schedules'
import ClassRoutine from './pages/ClassRoutine'
import TeacherRoutine from './pages/TeacherRoutine'
import Finance from './pages/Finance'

const theme = createTheme({
  palette: {
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
  },
})

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        <Layout>
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/departments" element={<Departments />} />
            <Route path="/programmes" element={<Programmes />} />
            <Route path="/semesters" element={<Semesters />} />
            <Route path="/teachers" element={<Teachers />} />
            <Route path="/subjects" element={<Subjects />} />
            <Route path="/classes" element={<Classes />} />
            <Route path="/days" element={<Days />} />
            <Route path="/periods" element={<Periods />} />
            <Route path="/class-routine" element={<ClassRoutine />} />
            <Route path="/teacher-routine" element={<TeacherRoutine />} />
            <Route path="/schedules" element={<Schedules />} />
            <Route path="/finance" element={<Finance />} />
          </Routes>
        </Layout>
      </Router>
    </ThemeProvider>
  )
}

export default App
