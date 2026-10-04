import { describe, it, expect } from 'vitest'
import {
  organizeModalitiesByYearAndFrame,
  getCurrentModality,
  getCurrentModalityFrames,
} from '../../pages/SportDetails/helpers'

const modality = (id: number, year: number, sport: string, frame = 'Masculino') => ({
  id, year, sport, frame, type: 'Torneio',
})

const data = {
  modalities: [
    modality(1, 2024, 'Futsal', 'Masculino'),
    modality(2, 2024, 'Futsal', 'Feminino'),
    modality(3, 2024, 'Voleibol'),
    modality(4, 2023, 'Futsal'),
  ],
} as never

describe('organizeModalitiesByYearAndFrame', () => {
  it('groups modalities by year, then by sport', () => {
    const grouped = organizeModalitiesByYearAndFrame(data) as Record<number, Record<string, { id: number }[]>>

    expect(Object.keys(grouped).sort()).toEqual(['2023', '2024'])
    expect(grouped[2024].Futsal.map((m) => m.id)).toEqual([1, 2])
    expect(grouped[2024].Voleibol.map((m) => m.id)).toEqual([3])
    expect(grouped[2023].Futsal.map((m) => m.id)).toEqual([4])
  })

  it('returns an empty object when there are no modalities', () => {
    expect(organizeModalitiesByYearAndFrame({ modalities: [] } as never)).toEqual({})
  })
})

describe('getCurrentModality', () => {
  it('finds the modality by its numeric id given as string', () => {
    expect(getCurrentModality('3', data).sport).toBe('Voleibol')
  })

  it('falls back to a sentinel with id -1 when the id is unknown', () => {
    expect(getCurrentModality('999', data)).toMatchObject({ id: -1, year: 0, sport: '' })
  })

  it('falls back to the sentinel for non numeric ids', () => {
    expect(getCurrentModality('abc', data).id).toBe(-1)
  })
})

describe('getCurrentModalityFrames', () => {
  it('lists the frames of the same sport and year only', () => {
    const current = getCurrentModality('1', data)

    expect(getCurrentModalityFrames(current, data)).toEqual([
      { frame: 'Masculino', id: 1 },
      { frame: 'Feminino', id: 2 },
    ])
  })

  it('returns nothing for the sentinel modality', () => {
    expect(getCurrentModalityFrames(getCurrentModality('x', data), data)).toEqual([])
  })
})
