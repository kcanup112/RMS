import { useState, useEffect } from 'react'
import { Typography, Paper, Grid, Card, CardContent, Box, Container } from '@mui/material'
import {
  Business as DepartmentIcon,
  Person as TeacherIcon,
  MenuBook as SubjectIcon,
  Schedule as ScheduleIcon,
  Class as ClassIcon,
  CalendarMonth as CalendarIcon,
} from '@mui/icons-material'
import { departmentService, teacherService, subjectService, classService } from '../services'

const StatCard = ({ title, value, icon, gradient, loading }) => (
  <Card 
    elevation={3}
    sx={{ 
      background: gradient,
      color: 'white',
      transition: 'all 0.3s ease',
      '&:hover': {
        transform: 'translateY(-8px)',
        boxShadow: 6,
      },
    }}
  >
    <CardContent sx={{ p: 3 }}>
      <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <Box>
          <Typography variant="h3" sx={{ fontWeight: 'bold', mb: 1 }}>
            {loading ? '...' : value}
          </Typography>
          <Typography variant="h6" sx={{ opacity: 0.9 }}>
            {title}
          </Typography>
        </Box>
        <Box sx={{ 
          bgcolor: 'rgba(255,255,255,0.2)', 
          borderRadius: '50%', 
          p: 2,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center'
        }}>
          {icon}
        </Box>
      </Box>
    </CardContent>
  </Card>
)

export default function Dashboard() {
  const [stats, setStats] = useState({
    departments: 0,
    teachers: 0,
    subjects: 0,
    classes: 0,
    schedules: 0,
    days: 5,
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    loadStats()
  }, [])

  const loadStats = async () => {
    setLoading(true)
    try {
      const [deptRes, teacherRes, subjectRes, classRes] = await Promise.all([
        departmentService.getAll(),
        teacherService.getAll(),
        subjectService.getAll(),
        classService.getAll(),
      ])

      setStats({
        departments: Array.isArray(deptRes.data) ? deptRes.data.length : 0,
        teachers: Array.isArray(teacherRes.data) ? teacherRes.data.length : 0,
        subjects: Array.isArray(subjectRes.data) ? subjectRes.data.length : 0,
        classes: Array.isArray(classRes.data) ? classRes.data.length : 0,
        schedules: 0, // This would need a schedules endpoint
        days: 5,
      })
    } catch (error) {
      console.error('Error loading stats:', error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <Container maxWidth="xl">
      <Box sx={{ py: 4 }}>
        {/* Header Section */}
        <Box sx={{ mb: 5, textAlign: 'center' }}>
          <Typography 
            variant="h3" 
            sx={{ 
              fontWeight: 700,
              background: 'linear-gradient(45deg, #1976d2 30%, #21CBF3 90%)',
              backgroundClip: 'text',
              textFillColor: 'transparent',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
              mb: 1
            }}
          >
            KEC Routine Scheduler
          </Typography>
          <Typography variant="h6" color="text.secondary">
            Intelligent Class Schedule Management System
          </Typography>
        </Box>

        {/* Stats Cards */}
        <Grid container spacing={3} sx={{ mb: 4 }}>
          <Grid item xs={12} sm={6} md={4}>
            <StatCard
              title="Departments"
              value={stats.departments}
              icon={<DepartmentIcon sx={{ fontSize: 48 }} />}
              gradient="linear-gradient(135deg, #667eea 0%, #764ba2 100%)"
              loading={loading}
            />
          </Grid>
          <Grid item xs={12} sm={6} md={4}>
            <StatCard
              title="Teachers"
              value={stats.teachers}
              icon={<TeacherIcon sx={{ fontSize: 48 }} />}
              gradient="linear-gradient(135deg, #f093fb 0%, #f5576c 100%)"
              loading={loading}
            />
          </Grid>
          <Grid item xs={12} sm={6} md={4}>
            <StatCard
              title="Subjects"
              value={stats.subjects}
              icon={<SubjectIcon sx={{ fontSize: 48 }} />}
              gradient="linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)"
              loading={loading}
            />
          </Grid>
          <Grid item xs={12} sm={6} md={4}>
            <StatCard
              title="Classes"
              value={stats.classes}
              icon={<ClassIcon sx={{ fontSize: 48 }} />}
              gradient="linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)"
              loading={loading}
            />
          </Grid>
          <Grid item xs={12} sm={6} md={4}>
            <StatCard
              title="Schedules"
              value={stats.schedules}
              icon={<ScheduleIcon sx={{ fontSize: 48 }} />}
              gradient="linear-gradient(135deg, #fa709a 0%, #fee140 100%)"
              loading={loading}
            />
          </Grid>
          <Grid item xs={12} sm={6} md={4}>
            <StatCard
              title="Active Days"
              value={stats.days}
              icon={<CalendarIcon sx={{ fontSize: 48 }} />}
              gradient="linear-gradient(135deg, #30cfd0 0%, #330867 100%)"
              loading={loading}
            />
          </Grid>
        </Grid>

        {/* Welcome Section */}
        <Paper 
          elevation={3}
          sx={{ 
            p: 4, 
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            color: 'white',
            borderRadius: 3,
          }}
        >
          <Typography variant="h4" sx={{ fontWeight: 600, mb: 2 }}>
            Kantipur Engineering College Routine Schedular 🎓
          </Typography>
          <Typography variant="body1" sx={{ fontSize: '1.1rem', opacity: 0.95, lineHeight: 1.8 }}>
            Building Future Since 1998
          </Typography>
        </Paper>

        {/* Quick Actions */}
        <Grid container spacing={3} sx={{ mt: 2 }}>
          <Grid item xs={12} md={6}>
            <Paper 
              elevation={2}
              sx={{ 
                p: 3, 
                borderRadius: 2,
                border: '2px solid',
                borderColor: 'primary.main',
                transition: 'all 0.3s ease',
                '&:hover': {
                  transform: 'translateY(-4px)',
                  boxShadow: 4,
                }
              }}
            >
              <Typography variant="h6" sx={{ fontWeight: 600, color: 'primary.main', mb: 1 }}>
                ✨ Getting Started
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Set up your departments, add teachers and subjects, then create class routines with our intuitive drag-and-drop interface.
              </Typography>
            </Paper>
          </Grid>
          <Grid item xs={12} md={6}>
            <Paper 
              elevation={2}
              sx={{ 
                p: 3, 
                borderRadius: 2,
                border: '2px solid',
                borderColor: 'secondary.main',
                transition: 'all 0.3s ease',
                '&:hover': {
                  transform: 'translateY(-4px)',
                  boxShadow: 4,
                }
              }}
            >
              <Typography variant="h6" sx={{ fontWeight: 600, color: 'secondary.main', mb: 1 }}>
                Created By Department of Computer and Electronics Engineering (DoCE)
              </Typography>
              <Typography variant="body2" color="text.secondary">
                
              </Typography>
            </Paper>
          </Grid>
        </Grid>
      </Box>
    </Container>
  )
}
