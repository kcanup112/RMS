import { useState, useEffect } from 'react'
import {
  Typography,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  MenuItem,
  Paper,
} from '@mui/material'
import { DataGrid } from '@mui/x-data-grid'
import { Add as AddIcon, Edit as EditIcon, Delete as DeleteIcon } from '@mui/icons-material'
import { classService, semesterService, departmentService, roomService } from '../services'
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns'
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider'
import { DatePicker } from '@mui/x-date-pickers/DatePicker'

export default function Classes() {
  const [classes, setClasses] = useState([])
  const [semesters, setSemesters] = useState([])
  const [departments, setDepartments] = useState([])
  const [rooms, setRooms] = useState([])
  const [open, setOpen] = useState(false)
  const [editMode, setEditMode] = useState(false)
  const [editId, setEditId] = useState(null)
  const [formData, setFormData] = useState({
    name: '',
    section: '',
    semester_id: '',
    department_id: '',
    room_no: '',
    effective_date: null,
  })
  const [loading, setLoading] = useState(false)

  const loadClasses = async () => {
    try {
      const response = await classService.getAll()
      // Enrich class data with semester and department names
      const enrichedClasses = response.data.map(cls => {
        const semester = semesters.find(s => s.id === cls.semester_id)
        const department = departments.find(d => d.id === cls.department_id)
        return {
          ...cls,
          semester_name: semester?.name || 'N/A',
          department_name: department?.name || 'N/A',
        }
      })
      setClasses(enrichedClasses)
    } catch (error) {
      console.error('Error loading classes:', error)
    }
  }

  const loadSemesters = async () => {
    try {
      const response = await semesterService.getAll()
      setSemesters(response.data)
    } catch (error) {
      console.error('Error loading semesters:', error)
    }
  }

  const loadDepartments = async () => {
    try {
      const response = await departmentService.getAll()
      setDepartments(response.data)
    } catch (error) {
      console.error('Error loading departments:', error)
    }
  }

  const loadRooms = async () => {
    try {
      const response = await roomService.getAll()
      setRooms(response.data)
    } catch (error) {
      console.error('Error loading rooms:', error)
    }
  }

  useEffect(() => {
    loadDepartments()
    loadSemesters()
    loadRooms()
  }, [])

  useEffect(() => {
    if (semesters.length > 0 && departments.length > 0) {
      loadClasses()
    }
  }, [semesters, departments])

  const handleOpen = () => {
    setEditMode(false)
    setEditId(null)
    setFormData({
      name: '',
      section: '',
      semester_id: '',
      department_id: '',
      room_no: '',
      effective_date: null,
    })
    setOpen(true)
  }

  const handleClose = () => {
    setOpen(false)
    setEditMode(false)
    setEditId(null)
    setFormData({
      name: '',
      section: '',
      semester_id: '',
      department_id: '',
      room_no: '',
      effective_date: null,
    })
  }

  const handleEdit = (classData) => {
    setEditMode(true)
    setEditId(classData.id)
    setFormData({
      name: classData.name,
      section: classData.section,
      semester_id: classData.semester_id,
      department_id: classData.department_id,
      room_no: classData.room_no || '',
      effective_date: classData.effective_date ? new Date(classData.effective_date) : null,
    })
    setOpen(true)
  }

  const handleSubmit = async () => {
    setLoading(true)
    try {
      const submitData = {
        ...formData,
        effective_date: formData.effective_date 
          ? formData.effective_date.toISOString().split('T')[0]
          : null,
      }
      
      if (editMode) {
        await classService.update(editId, submitData)
      } else {
        await classService.create(submitData)
      }
      await loadClasses()
      handleClose()
    } catch (error) {
      console.error('Error saving class:', error)
      alert('Error saving class. Please check all fields.')
    }
    setLoading(false)
  }

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this class?')) {
      try {
        await classService.delete(id)
        await loadClasses()
      } catch (error) {
        console.error('Error deleting class:', error)
      }
    }
  }

  const columns = [
    { field: 'id', headerName: 'ID', width: 70 },
    { field: 'name', headerName: 'Class Name', width: 200 },
    { field: 'section', headerName: 'Section', width: 100 },
    { field: 'semester_name', headerName: 'Semester', width: 150 },
    { field: 'department_name', headerName: 'Department', width: 150 },
    { field: 'room_no', headerName: 'Room No.', width: 120 },
    { field: 'effective_date', headerName: 'Effective Date', width: 130 },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 150,
      renderCell: (params) => (
        <>
          <Button
            size="small"
            startIcon={<EditIcon />}
            onClick={() => handleEdit(params.row)}
            sx={{ mr: 1 }}
          >
            Edit
          </Button>
          <Button
            size="small"
            color="error"
            startIcon={<DeleteIcon />}
            onClick={() => handleDelete(params.row.id)}
          >
            Delete
          </Button>
        </>
      ),
    },
  ]

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
        <Typography variant="h4">Classes</Typography>
        <Button variant="contained" startIcon={<AddIcon />} onClick={handleOpen}>
          Add Class
        </Button>
      </div>

      <Paper sx={{ height: 600, width: '100%' }}>
        <DataGrid
          rows={classes}
          columns={columns}
          pageSize={10}
          rowsPerPageOptions={[10]}
          disableSelectionOnClick
        />
      </Paper>

      <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
        <DialogTitle>{editMode ? 'Edit Class' : 'Add New Class'}</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            margin="dense"
            label="Class Name"
            fullWidth
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            sx={{ mb: 2 }}
          />
          
          <TextField
            margin="dense"
            label="Section"
            fullWidth
            value={formData.section}
            onChange={(e) => setFormData({ ...formData, section: e.target.value })}
            placeholder="e.g., A, B, C"
            sx={{ mb: 2 }}
          />

          <TextField
            select
            margin="dense"
            label="Department"
            fullWidth
            value={formData.department_id}
            onChange={(e) => setFormData({ ...formData, department_id: e.target.value })}
            sx={{ mb: 2 }}
          >
            {departments.map((dept) => (
              <MenuItem key={dept.id} value={dept.id}>
                {dept.name}
              </MenuItem>
            ))}
          </TextField>

          <TextField
            select
            margin="dense"
            label="Semester"
            fullWidth
            value={formData.semester_id}
            onChange={(e) => setFormData({ ...formData, semester_id: e.target.value })}
            sx={{ mb: 2 }}
          >
            {semesters.map((semester) => (
              <MenuItem key={semester.id} value={semester.id}>
                {semester.name}
              </MenuItem>
            ))}
          </TextField>

          <TextField
            select
            margin="dense"
            label="Room Number"
            fullWidth
            value={formData.room_no}
            onChange={(e) => setFormData({ ...formData, room_no: e.target.value })}
            sx={{ mb: 2 }}
          >
            <MenuItem value="">
              <em>None</em>
            </MenuItem>
            {rooms.map((room) => (
              <MenuItem key={room.id} value={room.room_number}>
                {room.room_number}
              </MenuItem>
            ))}
          </TextField>

          <LocalizationProvider dateAdapter={AdapterDateFns}>
            <DatePicker
              label="Effective Date"
              value={formData.effective_date}
              onChange={(newValue) => setFormData({ ...formData, effective_date: newValue })}
              renderInput={(params) => <TextField {...params} fullWidth margin="dense" />}
              slotProps={{ textField: { fullWidth: true, margin: 'dense' } }}
            />
          </LocalizationProvider>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained" disabled={loading}>
            {loading ? 'Saving...' : editMode ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  )
}
