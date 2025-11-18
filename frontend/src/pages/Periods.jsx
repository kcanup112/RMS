import { useState, useEffect } from 'react'
import {
  Typography,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Paper,
} from '@mui/material'
import { DataGrid } from '@mui/x-data-grid'
import { Add as AddIcon, Edit as EditIcon, Delete as DeleteIcon } from '@mui/icons-material'
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns'
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider'
import { TimePicker } from '@mui/x-date-pickers/TimePicker'
import { periodService } from '../services'

export default function Periods() {
  const [periods, setPeriods] = useState([])
  const [open, setOpen] = useState(false)
  const [editMode, setEditMode] = useState(false)
  const [editId, setEditId] = useState(null)
  const [formData, setFormData] = useState({
    name: '',
    start_time: null,
    end_time: null,
    order: '',
  })
  const [loading, setLoading] = useState(false)

  const loadPeriods = async () => {
    try {
      const response = await periodService.getAll()
      setPeriods(response.data)
    } catch (error) {
      console.error('Error loading periods:', error)
    }
  }

  useEffect(() => {
    loadPeriods()
  }, [])

  const handleOpen = () => {
    setEditMode(false)
    setEditId(null)
    setFormData({ name: '', start_time: null, end_time: null, order: '' })
    setOpen(true)
  }

  const handleClose = () => {
    setOpen(false)
    setEditMode(false)
    setEditId(null)
    setFormData({ name: '', start_time: null, end_time: null, order: '' })
  }

  const handleEdit = (period) => {
    setEditMode(true)
    setEditId(period.id)
    
    // Parse time strings to Date objects
    const parseTime = (timeStr) => {
      if (!timeStr) return null
      const [hours, minutes, seconds] = timeStr.split(':')
      const date = new Date()
      date.setHours(parseInt(hours), parseInt(minutes), parseInt(seconds || 0))
      return date
    }

    setFormData({
      name: period.name,
      start_time: parseTime(period.start_time),
      end_time: parseTime(period.end_time),
      order: period.order,
    })
    setOpen(true)
  }

  const handleSubmit = async () => {
    setLoading(true)
    try {
      // Format time as HH:MM:SS
      const formatTime = (date) => {
        if (!date) return null
        const hours = String(date.getHours()).padStart(2, '0')
        const minutes = String(date.getMinutes()).padStart(2, '0')
        const seconds = '00'
        return `${hours}:${minutes}:${seconds}`
      }

      const submitData = {
        name: formData.name,
        start_time: formatTime(formData.start_time),
        end_time: formatTime(formData.end_time),
        order: parseInt(formData.order),
      }

      if (editMode) {
        await periodService.update(editId, submitData)
      } else {
        await periodService.create(submitData)
      }
      await loadPeriods()
      handleClose()
    } catch (error) {
      console.error('Error saving period:', error)
      alert('Error saving period. Please check all fields.')
    }
    setLoading(false)
  }

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this period?')) {
      try {
        await periodService.delete(id)
        await loadPeriods()
      } catch (error) {
        console.error('Error deleting period:', error)
      }
    }
  }

  const columns = [
    { field: 'id', headerName: 'ID', width: 70 },
    { field: 'order', headerName: 'Order', width: 80 },
    { field: 'name', headerName: 'Period Name', width: 150 },
    { field: 'start_time', headerName: 'Start Time', width: 120 },
    { field: 'end_time', headerName: 'End Time', width: 120 },
    {
      field: 'duration',
      headerName: 'Duration',
      width: 100,
      renderCell: (params) => {
        const start = params.row.start_time
        const end = params.row.end_time
        if (start && end) {
          const [sh, sm] = start.split(':').map(Number)
          const [eh, em] = end.split(':').map(Number)
          const minutes = (eh * 60 + em) - (sh * 60 + sm)
          return `${minutes} min`
        }
        return ''
      },
    },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 200,
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
        <Typography variant="h4">Periods</Typography>
        <Button variant="contained" startIcon={<AddIcon />} onClick={handleOpen}>
          Add Period
        </Button>
      </div>

      <Paper sx={{ height: 600, width: '100%' }}>
        <DataGrid
          rows={periods}
          columns={columns}
          pageSize={10}
          rowsPerPageOptions={[10]}
          disableSelectionOnClick
        />
      </Paper>

      <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
        <DialogTitle>{editMode ? 'Edit Period' : 'Add New Period'}</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            margin="dense"
            label="Period Name"
            fullWidth
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            placeholder="e.g., 1st Period, 2nd Period"
            sx={{ mb: 2, mt: 1 }}
          />

          <LocalizationProvider dateAdapter={AdapterDateFns}>
            <TimePicker
              label="Start Time"
              value={formData.start_time}
              onChange={(newValue) => setFormData({ ...formData, start_time: newValue })}
              slotProps={{ textField: { fullWidth: true, margin: 'dense', sx: { mb: 2 } } }}
            />

            <TimePicker
              label="End Time"
              value={formData.end_time}
              onChange={(newValue) => setFormData({ ...formData, end_time: newValue })}
              slotProps={{ textField: { fullWidth: true, margin: 'dense', sx: { mb: 2 } } }}
            />
          </LocalizationProvider>

          <TextField
            margin="dense"
            label="Order"
            type="number"
            fullWidth
            value={formData.order}
            onChange={(e) => setFormData({ ...formData, order: e.target.value })}
            placeholder="e.g., 1, 2, 3"
          />
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
