import { tasksSlice, index, create, get, update, destroy } from './tasksSlice'
const fetchMock = require('fetch-mock-jest')

const reducer = tasksSlice.reducer
const actions = tasksSlice.actions

const initialState = {
  tasks: [],
  pending: false,
}

describe('tasks slice', () => {
  it('should return the initial state', () => {
    expect(reducer(undefined, {})).toEqual(initialState)
  })

  describe('edit actions', () => {
    const task = {
      id: 1,
      name: 'task1',
      description: 'description1',
      edit: false,
    }

    describe('show', () => {
      it('should set edit.name as true', () => {
        const action = actions.show(task.id)
        const actual = reducer({ tasks: [{ ...task, edit: true }] }, action)

        expect(actual.tasks[0].edit).toEqual(false)
      })
    })
    describe('edit', () => {
      it('should set edit.name as false', () => {
        const action = actions.edit(task.id)
        const actual = reducer({ tasks: [task] }, action)

        expect(actual.tasks[0].edit).toEqual(true)
      })
    })
  })

  describe('async thunks', () => {
    afterEach(() => fetchMock.restore())

    describe('index', () => {
      const item1 = {
        id: 1,
        name: 'task1',
      }
      const item2 = {
        id: 2,
        name: 'task2',
      }
      const endpoint = 'http://localhost:3000/tasks.json'

      it('should GET /tasks.json', async () => {
        const action = index()
        fetchMock.get(endpoint, {
          status: 200,
          body: JSON.stringify([item1, item2]),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(subject.payload).toEqual([item1, item2])
        expect(fetchMock).toHaveFetched(endpoint)
      })

      it('should set pending=true when initiated', () => {
        const actual = reducer(initialState, index.pending())
        expect(actual.pending).toBe(true)
      })

      it('should set pending=false when API call has finished', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          index.fulfilled([])
        )
        expect(actual.pending).toBe(false)
      })

      it('should update the list', () => {
        const apiRet = [item1, item2]
        const expected = apiRet.map((i) => ({
          ...i,
          edit: false,
        }))

        const actual = reducer(
          {
            ...initialState,
            tasks: [
              {
                id: 0,
                name: 'existing task',
                edit: false,
              },
            ],
          },
          index.fulfilled(apiRet)
        )

        expect(actual.tasks.length).toEqual(expected.length)
        expect(actual.tasks).toEqual(expected)
      })

      it('should set pending=false when API call has failed', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          index.rejected()
        )
        expect(actual.pending).toBe(false)
      })
    })

    describe('create', () => {
      const newItem = {
        id: 1,
        name: 'new task name',
      }
      const endpoint = 'http://localhost:3000/tasks.json'

      it('should POST /tasks.json', async () => {
        const action = create({ name: newItem.name })
        fetchMock.post(endpoint, {
          status: 201,
          body: JSON.stringify(newItem),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(
          (u, o) =>
            u == endpoint && o.body == JSON.stringify({ name: newItem.name })
        )
      })

      it('should set pending=true when initiated', () => {
        const actual = reducer(initialState, create.pending())
        expect(actual.pending).toBe(true)
      })

      it('should set pending=false when API call has finished', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          create.fulfilled(newItem)
        )
        expect(actual.pending).toBe(false)
      })

      it('should add the new item at beginning of the list', () => {
        const actual = reducer(
          { ...initialState, tasks: [{ id: 0, name: 'existing task' }] },
          create.fulfilled(newItem)
        )

        expect(actual.tasks.length).toEqual(2)
        expect(actual.tasks[0]).toEqual({
          ...newItem,
          edit: false,
        })
      })

      it('should set pending=false when API call has failed', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          create.rejected()
        )
        expect(actual.pending).toBe(false)
      })
    })

    describe('update', () => {
      const item = {
        id: 1,
        name: 'existing task name',
      }
      const updatedItem = { ...item, description: 'new description' }
      const endpoint = `http://localhost:3000/tasks/${item.id}.json`

      it('should PUT /tasks/1.json with new values as a payload', async () => {
        const action = update(updatedItem)
        fetchMock.put(endpoint, {
          status: 200,
          body: JSON.stringify(updatedItem),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(subject.payload).toEqual(updatedItem)
        expect(fetchMock).toHaveFetched(
          (u, o) => u == endpoint && o.body == JSON.stringify(updatedItem)
        )
      })

      it('should set pending=true when initiated', () => {
        const actual = reducer(initialState, update.pending())
        expect(actual.pending).toBe(true)
      })

      it('should set pending=false when API call has finished', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          update.fulfilled(updatedItem)
        )
        expect(actual.pending).toBe(false)
      })

      it('should add the new item at beginning of the list', () => {
        const actual = reducer(
          { ...initialState, tasks: [item] },
          update.fulfilled(updatedItem)
        )

        expect(actual.tasks[0]).toEqual({
          ...updatedItem,
          edit: false,
        })
      })

      it('should set pending=false when API call has failed', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          update.rejected()
        )
        expect(actual.pending).toBe(false)
      })
    })

    describe('destroy', () => {
      const item = {
        id: 1,
        name: 'existing task name',
      }
      const endpoint = `http://localhost:3000/tasks/${item.id}.json`

      it('should DELETE /tasks/1.json', async () => {
        const action = destroy({ id: item.id })
        fetchMock.delete(endpoint, {
          status: 204,
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(endpoint)
        expect(subject.payload.id).toEqual(item.id)
      })

      it('should set pending=true when initiated', () => {
        const actual = reducer(initialState, destroy.pending())
        expect(actual.pending).toBe(true)
      })

      it('should set pending=false when API call has finished', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          destroy.fulfilled({ id: item.id })
        )
        expect(actual.pending).toBe(false)
      })

      it('should add the new item at beginning of the list', () => {
        const actual = reducer(
          { ...initialState, tasks: [item, { ...item, ...{ id: 0 } }] },
          destroy.fulfilled({ id: item.id })
        )

        expect(actual.tasks.length).toEqual(1)
        expect(actual.tasks[0]).not.toEqual(item)
      })

      it('should set pending=false when API call has failed', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          destroy.rejected()
        )
        expect(actual.pending).toBe(false)
      })
    })
  })
})
