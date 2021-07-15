import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit'

const initialState: State = {
  tasks: [],
  pending: false,
  notice: null,
}

export const index = createAsyncThunk('task/index', async (params, _) => {
  const ret = await fetch('http://localhost:3000/tasks.json', {
    method: 'GET',
    mode: 'cors',
    headers: { 'Content-Type': 'application/json' },
  })

  if (ret.ok) return ret.json()
})

export const create = createAsyncThunk('task/create', async (params, _) => {
  const payload = {
    name: params.name,
  }
  const ret = await fetch('http://localhost:3000/tasks.json', {
    method: 'POST',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
  })

  if (ret.ok) {
    return ret.json()
  }
})

export const update = createAsyncThunk('task/update', async (params, _) => {
  const ret = await fetch(`http://localhost:3000/tasks/${params.id}.json`, {
    method: 'PUT',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(params),
  })

  if (ret.ok) return ret.json()
})

export const destroy = createAsyncThunk('task/destroy', async (params, _) => {
  const ret = await fetch(`http://localhost:3000/tasks/${params.id}.json`, {
    method: 'DELETE',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json',
    },
  })

  if (ret.ok) return { ...(await ret.json()), id: params.id }
})

const findTask = (state, id) => {
  return state.tasks.find((t) => id == t.id)
}

export const tasksSlice = createSlice({
  name: 'tasks',
  initialState,
  reducers: {
    show(state, action) {
      const target = findTask(state, action.payload)
      target.edit = false
    },
    edit(state, action) {
      const target = findTask(state, action.payload)
      target.edit = true
    },
    setNotice(state, action) {
      state.notice = action.payload
    },
  },

  extraReducers: (builder) => {
    ;[index, create, update, destroy].forEach((t) => {
      builder.addCase(t.pending, (s) => {
        s.pending = true
      })
      builder.addCase(t.rejected, (s) => {
        s.pending = false
      })
    })

    builder.addCase(index.fulfilled, (state, action) => {
      state.pending = false
      state.tasks = action.payload.map((i) => ({
        ...i,
        edit: false,
      }))
    })

    builder.addCase(create.fulfilled, (state, action) => {
      const { task, notice } = action.payload
      state.pending = false

      state.tasks = [{ ...task, edit: false }, ...state.tasks]
      state.notice = notice
    })

    builder.addCase(update.fulfilled, (state, action) => {
      const { task, notice } = action.payload
      state.pending = false

      const index = state.tasks.findIndex((t) => t.id == task.id)
      state.tasks[index] = {
        ...task,
        edit: false,
      }
      state.notice = notice
    })

    builder.addCase(destroy.fulfilled, (state, action) => {
      const { id, notice } = action.payload
      state.pending = false

      state.tasks = state.tasks.filter((t) => t.id != id)
      state.notice = notice
    })
  },
})
