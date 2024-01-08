using module .\LaRainbow.psm1
using module .\Ansi.psm1
using module .\NotWindows.psm1
using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host
using namespace System.Media

Add-Type -AssemblyName PresentationCore

Enum ProgramState {
    CanvasTypeSelection
    ColorSelection
    CanvasPaint
}

[ProgramState]$Script:GlobalState = [ProgramState]::CanvasTypeSelection

[ProgramCore]$Script:TheProgram                        = [ProgramCore]::new()
[CanvasTypeSelectionWindow]$Script:TheCanvasTypeWindow = $null

$Script:Rui             = $(Get-Host).UI.RawUI
$Script:StateBlockTable = @{
    [ProgramState]::CanvasTypeSelection = {
        If($null -EQ $Script:TheCanvasTypeWindow) {
            $Script:TheCanvasTypeWindow = [CanvasTypeSelectionWindow]::new()
        }

        $Script:TheCanvasTypeWindow.Draw()
        $Script:TheCanvasTypeWindow.HandleInput()
    }

    [ProgramState]::ColorSelection = {}

    [ProgramState]::CanvasPaint = {}
}

Class CanvasTypeSelectionWindow : WindowBase {
    Static [Int16]$LineCompositeChevronA   = 0
    Static [Int16]$LineCompositeLabelA     = 1
    Static [Int16]$LineCompositeChevronB   = 2
    Static [Int16]$LineCompositeLabelB     = 3
    Static [String]$ChevronCharacterActual = '>'
    Static [String]$ChevronBlankActual     = ' '
    Static [String]$LineBlankActual        = '                  '
    Static [String]$OptionALabel           = 'Scene'
    Static [String]$OptionBLabel           = 'Enemy'
    
    Static [ATString]$LineBlank = [ATString]@{
        Prefix = [ATStringPrefix]@{
            ForegroundColor = [CCBlack24]::new()
            BackgroundColor = [CCBlack24]::new()
            Decoration      = [ATDecorationNone]::new()
            Coordinates     = [ATCoordinatesNone]::new()
        }
        UserData   = [CanvasTypeSelectionWindow]::LineBlankActual
        UseATReset = $true
    }

    [Boolean]$ChevronDirty
    [Boolean]$ActiveItemBlinking
    [Boolean]$LineDirty

    [List[ValueTuple[[ATString], [Boolean]]]]$ChevronList

    [Int16]$ActiveChevronIndex

    [ATCoordinates]$OptionALabelDrawCoordinates
    [ATCoordinates]$OptionBLabelDrawCoordinates

    [ATStringComposite]$LineComposite

    CanvasTypeSelectionWindow(): base() {
        $this.WindowLTRow            = 1
        $this.WindowLTColumn         = 1
        $this.WindowRBRow            = 3
        $this.WindowRBColumn         = 21
        $this.WindowBorderHorizontal = '*------------------*'
        $this.WindowBorderVertical   = '|'
        $this.Initialize()

        $this.ChevronDirty                = $true
        $this.ActiveItemBlinking          = $false
        $this.LineDirty                   = $true
        $this.ChevronList                 = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.ActiveChevronIndex          = 0
        $this.OptionALabelDrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 1
            Column = $this.LeftTop.Column + 4
        }
        $this.OptionBLabelDrawCoordinates = [ATCoordinates]@{
            Row    = $this.LeftTop.Row + 2
            Column = $this.LeftTop.Column + 13
        }
        $this.CreateChevrons()
        $this.CreateLineComposite()
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.LineDirty -EQ $true) {
            Write-Host "$($this.LineComposite.ToAnsiControlSequenceString())"
            $this.LineDirty = $false
        }
    }

    [Void]CreateChevrons() {
        $this.ChevronList = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.ChevronList.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleNGreenLight24]::new()
                        BackgroundColor = [ATBackgroundColor24None]::new()
                        Decorations     = [ATDecorationNone]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = $this.LeftTop.Column + 2
                        }
                    }
                    UserData   = [CanvasTypeSelectionWindow]::ChevronCharacterActual
                    UseATReset = $true
                },
                $true
            )
        )
        $this.ChevronList.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleNGreenLight24]::new()
                        BackgroundColor = [ATBackgroundColor24None]::new()
                        Decorations     = [ATDecorationNone]::new()
                        Coordinates     = [ATCoordinates]@{
                            Row    = $this.LeftTop.Row + 1
                            Column = $this.LeftTop.Column + 2
                        }
                    }
                    UserData   = [CanvasTypeSelectionWindow]::ChevronBlankActual
                    UseATReset = $true
                },
                $false
            )
        )
    }

    [ATString]GetActiveChevron() {
        Foreach($a in $this.ChevronList) {
            If($a.Item2 -EQ $true) {
                Return $a.Item1
            }
        }
        $this.ActiveChevronIndex                          = 0
        $this.ChevronList[$this.ActiveChevronIndex].Item2 = $true
        
        Return $this.ChevronList[$this.ActiveChevronIndex].Item1
    }

    [Void]ResetChevronPosition() {
        $this.ChevronList[$this.ActiveChevronIndex].Item2          = $false
        $this.ChevronList[$this.ActiveChevronIndex].Item1.UserData = [CanvasTypeSelectionWindow]::ChevronBlankActual
        $this.ActiveChevronIndex                                   = 0
        $this.ChevronList[$this.ActiveChevronIndex].Item2          = $true
        $this.ChevronList[$this.ActiveChevronIndex].Item1.UserData = [CanvasTypeSelectionWindow]::ChevronCharacterActual
    }

    [Void]CreateLineComposite() {
        $this.LineComposite = [ATStringComposite]@{
            CompositeActual = @(
                $this.ChevronList[0].Item1,
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        BackgroundColor = [ATBackgroundColor24None]::new()
                        Decorations     = [ATDecorationNone]::new()
                        Coordinates     = $this.OptionALabelDrawCoordinates
                    }
                    UserData   = [CanvasTypeSelectionWindow]::OptionALabel
                    UseATReset = $true
                },
                $this.ChevronList[1].Item1,
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCTextDefault24]::new()
                        BackgroundColor = [ATBackgroundColor24None]::new()
                        Decorations     = [ATDecorationNone]::new()
                        Coordinates     = $this.OptionBLabelDrawCoordinates
                    }
                    UserData   = [CanvasTypeSelectionWindow]::OptionBLabel
                    UseATReset = $true
                }
            )
        }
    }

    [Void]HandleInput() {
        $KeyCap = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
        Switch($KeyCap.VirtualKeyCode) {
            37 { # Left
                If(($this.ActiveChevronIndex - 1) -GE 0) {
                    $this.ChevronList[$this.ActiveChevronIndex].Item2          = $false
                    $this.ChevronList[$this.ActiveChevronIndex].Item1.UserData = [CanvasTypeSelectionWindow]::ChevronBlankActual
                    $this.ActiveChevronIndex--
                } Elseif(($this.ActiveChevronIndex - 1) -LT 0) {
                    $this.ChevronList[$this.ActiveChevronIndex].Item2          = $false
                    $this.ChevronList[$this.ActiveChevronIndex].Item1.UserData = [CanvasTypeSelectionWindow]::ChevronBlankActual
                    $this.ActiveChevronIndex                                   = 1
                }
                $this.ChevronList[$this.ActiveChevronIndex].Item2          = $true
                $this.ChevronList[$this.ActiveChevronIndex].Item1.UserData = [CanvasTypeSelectionWindow]::ChevronCharacterActual
                $this.LineDirty                                            = $false

                Return
            }

            39 { # Right
                If(($this.ActiveChevronIndex - 1) -GE 0) {
                    $this.ChevronList[$this.ActiveChevronIndex].Item2          = $false
                    $this.ChevronList[$this.ActiveChevronIndex].Item1.UserData = [CanvasTypeSelectionWindow]::ChevronBlankActual
                    $this.ActiveChevronIndex--
                } Elseif(($this.ActiveChevronIndex - 1) -LT 0) {
                    $this.ChevronList[$this.ActiveChevronIndex].Item2          = $false
                    $this.ChevronList[$this.ActiveChevronIndex].Item1.UserData = [CanvasTypeSelectionWindow]::ChevronBlankActual
                    $this.ActiveChevronIndex                                   = 1
                }
                $this.ChevronList[$this.ActiveChevronIndex].Item2          = $true
                $this.ChevronList[$this.ActiveChevronIndex].Item1.UserData = [CanvasTypeSelectionWindow]::ChevronCharacterActual
                $this.LineDirty                                            = $false

                Return
            }

            Default {
                $Script:Rui.CursorPosition = [Coordinates]::new(1, 1)
                $Script:Rui.FlushInputBuffer()

                Return
            }
        }
    }
}

Class ProgramCore {
    [Boolean]$Running

    ProgramCore() {
        $this.Running = $true
    }

    [Void]Run() {
        While($this.Running -EQ $true) {
            $this.Logic()
        }
    }

    [Void]Logic() {
        Invoke-Command $Script:StateBlockTable[$Script:GlobalState]
        $Script:Rui.FlushInputBuffer()
    }
}

$Script:TheProgram.Run()
