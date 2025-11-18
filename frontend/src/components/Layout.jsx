import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  AppBar,
  Box,
  CssBaseline,
  Drawer,
  IconButton,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Toolbar,
  Typography,
  Collapse,
  Divider,
} from '@mui/material'
import {
  Menu as MenuIcon,
  Dashboard as DashboardIcon,
  Business as DepartmentIcon,
  School as ProgrammeIcon,
  CalendarMonth as SemesterIcon,
  Person as TeacherIcon,
  MenuBook as SubjectIcon,
  Class as ClassIcon,
  Today as DayIcon,
  AccessTime as PeriodIcon,
  Schedule as ScheduleIcon,
  ExpandLess,
  ExpandMore,
  Settings as SettingsIcon,
  GroupWork as AcademicIcon,
  ViewList as RoutineIcon,
  TableChart as ClassRoutineIcon,
  PersonOutline as TeacherRoutineIcon,
  VisibilityOff as HideIcon,
  Visibility as ShowIcon,
  AttachMoney as FinanceIcon,
} from '@mui/icons-material'

const drawerWidth = 240

const menuSections = [
  {
    title: 'Academic Setup',
    icon: <AcademicIcon />,
    items: [
      { text: 'Departments', icon: <DepartmentIcon />, path: '/departments' },
      { text: 'Programmes', icon: <ProgrammeIcon />, path: '/programmes' },
      { text: 'Semesters', icon: <SemesterIcon />, path: '/semesters' },
      { text: 'Classes', icon: <ClassIcon />, path: '/classes' },
    ]
  },
  {
    title: 'Resources',
    icon: <SettingsIcon />,
    items: [
      { text: 'Teachers', icon: <TeacherIcon />, path: '/teachers' },
      { text: 'Subjects', icon: <SubjectIcon />, path: '/subjects' },
      { text: 'Days', icon: <DayIcon />, path: '/days' },
      { text: 'Periods', icon: <PeriodIcon />, path: '/periods' },
    ]
  },
  {
    title: 'Routine',
    icon: <RoutineIcon />,
    items: [
      { text: 'Class Routine', icon: <ClassRoutineIcon />, path: '/class-routine' },
      { text: 'Teacher Routine', icon: <TeacherRoutineIcon />, path: '/teacher-routine' },
    ]
  },
]

export default function Layout({ children }) {
  const [mobileOpen, setMobileOpen] = useState(false)
  const [openSections, setOpenSections] = useState({
    'Academic Setup': true,
    'Resources': true,
    'Routine': true,
  })
  const [sidebarVisible, setSidebarVisible] = useState(true)
  const navigate = useNavigate()

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen)
  }

  const handleNavigation = (path) => {
    navigate(path)
    setMobileOpen(false)
  }

  const handleSectionToggle = (section) => {
    setOpenSections(prev => ({
      ...prev,
      [section]: !prev[section]
    }))
  }

  const handleToggleSidebar = () => {
    setSidebarVisible(!sidebarVisible)
  }

  const drawer = (
    <Box sx={{ 
      height: '100%',
      background: 'linear-gradient(180deg, #667eea 0%, #764ba2 100%)',
      color: 'white',
    }}>
      <Toolbar sx={{ 
        display: 'flex', 
        justifyContent: 'space-between', 
        alignItems: 'center',
        background: 'rgba(255,255,255,0.1)',
        backdropFilter: 'blur(10px)',
      }}>
        <Typography variant="h6" noWrap component="div" sx={{ fontWeight: 700 }}>
          📚 KEC Routine
        </Typography>
        <IconButton 
          size="small" 
          onClick={handleToggleSidebar}
          title="Hide Sidebar"
          sx={{ 
            ml: 1,
            bgcolor: 'rgba(255,255,255,0.2)',
            color: 'white',
            '&:hover': {
              bgcolor: 'rgba(255,255,255,0.3)',
            },
          }}
        >
          <HideIcon fontSize="small" />
        </IconButton>
      </Toolbar>
      <Divider sx={{ borderColor: 'rgba(255,255,255,0.2)' }} />
      
      <List sx={{ px: 1, py: 2 }}>
        {/* Dashboard - Always visible */}
        <ListItem disablePadding sx={{ mb: 1 }}>
          <ListItemButton 
            onClick={() => handleNavigation('/')}
            sx={{ 
              borderRadius: 2,
              '&:hover': {
                bgcolor: 'rgba(255,255,255,0.15)',
              },
            }}
          >
            <ListItemIcon sx={{ color: 'white' }}>
              <DashboardIcon />
            </ListItemIcon>
            <ListItemText 
              primary="Dashboard" 
              primaryTypographyProps={{ fontWeight: 500, color: 'white' }}
            />
          </ListItemButton>
        </ListItem>
        
        <Divider sx={{ my: 2, borderColor: 'rgba(255,255,255,0.2)' }} />
        
        {/* Collapsible Sections */}
        {menuSections.map((section) => (
          <Box key={section.title} sx={{ mb: 1 }}>
            <ListItemButton 
              onClick={() => handleSectionToggle(section.title)}
              sx={{ 
                borderRadius: 2,
                bgcolor: 'rgba(255,255,255,0.1)',
                mb: 0.5,
                '&:hover': {
                  bgcolor: 'rgba(255,255,255,0.2)',
                },
              }}
            >
              <ListItemIcon sx={{ color: 'white' }}>{section.icon}</ListItemIcon>
              <ListItemText 
                primary={section.title} 
                primaryTypographyProps={{ fontWeight: 600, fontSize: '0.9rem', color: 'white' }}
              />
              {openSections[section.title] ? <ExpandLess sx={{ color: 'white' }} /> : <ExpandMore sx={{ color: 'white' }} />}
            </ListItemButton>
            
            <Collapse in={openSections[section.title]} timeout="auto" unmountOnExit>
              <List component="div" disablePadding>
                {section.items.map((item) => (
                  <ListItemButton
                    key={item.text}
                    sx={{ 
                      pl: 4, 
                      py: 0.5,
                      borderRadius: 2,
                      '&:hover': {
                        bgcolor: 'rgba(255,255,255,0.1)',
                      },
                    }}
                    onClick={() => handleNavigation(item.path)}
                  >
                    <ListItemIcon sx={{ color: 'rgba(255,255,255,0.8)', minWidth: 40 }}>
                      {item.icon}
                    </ListItemIcon>
                    <ListItemText 
                      primary={item.text} 
                      primaryTypographyProps={{ fontSize: '0.875rem', color: 'white' }}
                    />
                  </ListItemButton>
                ))}
              </List>
            </Collapse>
          </Box>
        ))}
        
        <Divider sx={{ my: 2, borderColor: 'rgba(255,255,255,0.2)' }} />
        
        {/* Load Report - Always visible */}
        <ListItem disablePadding sx={{ mb: 1 }}>
          <ListItemButton 
            onClick={() => handleNavigation('/schedules')}
            sx={{ 
              borderRadius: 2,
              '&:hover': {
                bgcolor: 'rgba(255,255,255,0.15)',
              },
            }}
          >
            <ListItemIcon sx={{ color: 'white' }}>
              <ScheduleIcon />
            </ListItemIcon>
            <ListItemText 
              primary="Load Report" 
              primaryTypographyProps={{ fontWeight: 500, color: 'white' }}
            />
          </ListItemButton>
        </ListItem>
        
        {/* Finance - Always visible */}
        <ListItem disablePadding>
          <ListItemButton 
            onClick={() => handleNavigation('/finance')}
            sx={{ 
              borderRadius: 2,
              '&:hover': {
                bgcolor: 'rgba(3, 49, 52, 0.15)',
              },
            }}
          >
            <ListItemIcon sx={{ color: 'white' }}>
              <FinanceIcon />
            </ListItemIcon>
            <ListItemText 
              primary="Finance" 
              primaryTypographyProps={{ fontWeight: 500, color: 'blue' }}
            />
          </ListItemButton>
        </ListItem>
      </List>
    </Box>
  )

  return (
    <Box sx={{ display: 'flex' }}>
      <CssBaseline />
      <AppBar
        position="fixed"
        elevation={0}
        sx={{
          width: { sm: sidebarVisible ? `calc(100% - ${drawerWidth}px)` : '100%' },
          ml: { sm: sidebarVisible ? `${drawerWidth}px` : 0 },
          transition: 'width 0.3s, margin 0.3s',
          background: 'linear-gradient(90deg, #667eea 0%, #764ba2 100%)',
          borderBottom: '1px solid rgba(255,255,255,0.2)',
        }}
      >
        <Toolbar>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleToggleSidebar}
            sx={{ 
              mr: 2, 
              display: { xs: 'none', sm: 'block' },
              bgcolor: 'rgba(255,255,255,0.1)',
              '&:hover': {
                bgcolor: 'rgba(255,255,255,0.2)',
              },
            }}
          >
            {sidebarVisible ? <HideIcon /> : <ShowIcon />}
          </IconButton>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
            sx={{ 
              mr: 2, 
              display: { xs: 'block', sm: 'none' },
              bgcolor: 'rgba(255,255,255,0.1)',
              '&:hover': {
                bgcolor: 'rgba(255,255,255,0.2)',
              },
            }}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" noWrap component="div" sx={{ fontWeight: 600 }}>
            KEC Routine Scheduler
          </Typography>
          <Box sx={{ flexGrow: 1 }} />
          <Typography variant="body2" sx={{ opacity: 0.9 }}>
            Academic Year 2025
          </Typography>
        </Toolbar>
      </AppBar>
      <Box
        component="nav"
        sx={{ width: { sm: sidebarVisible ? drawerWidth : 0 }, flexShrink: { sm: 0 }, transition: 'width 0.3s' }}
      >
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={handleDrawerToggle}
          ModalProps={{
            keepMounted: true,
          }}
          sx={{
            display: { xs: 'block', sm: 'none' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
        >
          {drawer}
        </Drawer>
        <Drawer
          variant="permanent"
          sx={{
            display: { xs: 'none', sm: sidebarVisible ? 'block' : 'none' },
            '& .MuiDrawer-paper': { boxSizing: 'border-box', width: drawerWidth },
          }}
          open
        >
          {drawer}
        </Drawer>
      </Box>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          p: 3,
          width: { sm: sidebarVisible ? `calc(100% - ${drawerWidth}px)` : '100%' },
          transition: 'width 0.3s',
          bgcolor: '#f5f7fa',
          minHeight: '100vh',
        }}
      >
        <Toolbar />
        {children}
      </Box>
    </Box>
  )
}
