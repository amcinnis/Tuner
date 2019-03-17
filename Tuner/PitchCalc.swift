//
//  PitchCalc.swift
//  Tuner
//
//  Created by Austin McInnis on 3/17/19.
//  Copyright © 2019 Austin McInnis. All rights reserved.
//
//  Pitch calculation formula derived from John D. Cook
//  Source: https://www.johndcook.com/blog/2016/02/10/musical-pitch-notation/

import Foundation

func getPitch(from frequency: Double) throws -> (note: Note, octave: Int) {
    let temperament = Temperament.Equal
    let C0 = temperament.rawValue*pow(2.0, -4.75)
    
    // halfSteps = Number of half steps from C0 to P
    let halfSteps = round(12.0 * log2(frequency/C0))
    let octave = Int(halfSteps / 12.0)
    let n = Int(halfSteps.truncatingRemainder(dividingBy: 12.0))
    guard let note = Note(rawValue: n) else {
        throw TunerError.invalidNote
    }
    
    return (note, octave)
}

enum Note: Int {
    case C
    case Csharp
    case D
    case Dsharp
    case E
    case F
    case Fsharp
    case G
    case Gsharp
    case A
    case Asharp
    case B
    
    var description: String {
        switch self {
            case .C:        return "C"
            case .Csharp:   return "C#"
            case .D:        return "D"
            case .Dsharp:   return "D#"
            case .E:        return "E"
            case .F:        return "F"
            case .Fsharp:   return "F#"
            case .G:        return "G"
            case .Gsharp:   return "G#"
            case .A:        return "A"
            case .Asharp:   return "A#"
            case .B:        return "B"
        }
    }
}

enum Temperament: Double {
    case Equal = 440.0
}
