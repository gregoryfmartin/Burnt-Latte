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

Class ConsoleColor24 {
    [ValidateRange(0, 255)][Int]$Red
    [ValidateRange(0, 255)][Int]$Green
    [ValidateRange(0, 255)][Int]$Blue

    ConsoleColor24() {
        $this.Red   = 0
        $this.Green = 0
        $this.Blue  = 0
    }

    ConsoleColor24(
        [Int]$Red,
        [Int]$Green,
        [Int]$Blue
    ) {
        $this.Red   = $Red
        $this.Green = $Green
        $this.Blue  = $Blue
    }

    ConsoleColor24(
        [ConsoleColor24]$CopyFrom
    ) {
        $this.Red   = $CopyFrom.Red
        $this.Green = $CopyFrom.Green
        $this.Blue  = $CopyFrom.Blue
    }
}

Class CCBlack24 : ConsoleColor24 {
    CCBlack24() : base(0, 0, 0) {}
}

Class CCWhite24 : ConsoleColor24 {
    CCWhite24() : base(255, 255, 255) {}
}

Class CCRed24 : ConsoleColor24 {
    CCRed24() : base(255, 0, 0) {}
}

Class CCGreen24 : ConsoleColor24 {
    CCGreen24() : base(0, 255, 0) {}
}

Class CCBlue24 : ConsoleColor24 {
    CCBlue24() : base (0, 0, 255) {}
}

Class CCYellow24 : ConsoleColor24 {
    CCYellow24() : base(255, 255, 0) {}
}

Class CCDarkYellow24 : ConsoleColor24 {
    CCDarkYellow24() : base(255, 204, 0) {}
}

Class CCDarkCyan24 : ConsoleColor24 {
    CCDarkCyan24() : base(0, 139, 139) {}
}

Class CCDarkGrey24 : ConsoleColor24 {
    CCDarkGrey24() : base(45, 45, 45) {}
}

Class CCRandom24 : ConsoleColor24 {
    CCRandom24() : base($(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0), $(Get-Random -Maximum 255 -Minimum 0)) {}
}

Class CCAppleNRedLight24 : ConsoleColor24 {
    CCAppleNRedLight24() : base(255, 59, 48) {}
}

Class CCAppleNRedDark24 : ConsoleColor24 {
    CCAppleNRedDark24() : base(255, 69, 58) {}
}

Class CCAppleNRedALight24 : ConsoleColor24 {
    CCAppleNRedALight24() : base(215, 0, 21) {}
}

Class CCAppleNRedADark24 : ConsoleColor24 {
    CCAppleNRedADark24() : base(255, 105, 97) {}
}

Class CCAppleNOrangeLight24 : ConsoleColor24 {
    CCAppleNOrangeLight24() : base(255, 149, 0) {}
}

Class CCAppleNOrangeDark24 : ConsoleColor24 {
    CCAppleNOrangeDark24() : base(255, 159, 10) {}
}

Class CCAppleNOrangeALight24 : ConsoleColor24 {
    CCAppleNOrangeALight24() : base(201, 52, 0) {}
}

Class CCAppleNOrangeADark24 : ConsoleColor24 {
    CCAppleNOrangeADark24() : base(255, 179, 64) {}
}

Class CCAppleNYellowLight24 : ConsoleColor24 {
    CCAppleNYellowLight24() : base(255, 204, 0) {}
}

Class CCAppleNYellowDark24 : ConsoleColor24 {
    CCAppleNYellowDark24() : base(255, 214, 10) {}
}

Class CCAppleNYellowALight24 : ConsoleColor24 {
    CCAppleNYellowALight24() : base(178, 80, 0) {}
}

Class CCAppleNYellowADark24 : ConsoleColor24 {
    CCAppleNYellowADark24() : base(255, 212, 38) {}
}

Class CCAppleNGreenLight24 : ConsoleColor24 {
    CCAppleNGreenLight24() : base(52, 199, 89) {}
}

Class CCAppleNGreenDark24 : ConsoleColor24 {
    CCAppleNGreenDark24() : base(48, 209, 88) {}
}

Class CCAppleNGreenALight24 : ConsoleColor24 {
    CCAppleNGreenALight24() : base(36, 138, 61) {}
}

Class CCAppleNGreenADark24 : ConsoleColor24 {
    CCAppleNGreenADark24() : base(48, 219, 91) {}
}

Class CCAppleNMintLight24 : ConsoleColor24 {
    CCAppleNMintLight24() : base(0, 199, 190) {}
}

Class CCAppleNMintDark24 : ConsoleColor24 {
    CCAppleNMintDark24() : base(99, 230, 226) {}
}

Class CCAppleNMintALight24 : ConsoleColor24 {
    CCAppleNMintALight24() : base(12, 129, 123) {}
}

Class CCAppleNMintADark24 : ConsoleColor24 {
    CCAppleNMintADark24() : base(102, 212, 207) {}
}

Class CCAppleNTealLight24 : ConsoleColor24 {
    CCAppleNTealLight24() : base(48, 176, 199) {}
}

Class CCAppleNTealDark24 : ConsoleColor24 {
    CCAppleNTealDark24() : base(64, 200, 224) {}
}

Class CCAppleNTealALight24 : ConsoleColor24 {
    CCAppleNTealALight24() : base(0, 130, 153) {}
}

Class CCAppleNTealADark24 : ConsoleColor24 {
    CCAppleNTealADark24() : base(93, 230, 255) {}
}

Class CCAppleNCyanLight24 : ConsoleColor24 {
    CCAppleNCyanLight24() : base(50, 173, 230) {}
}

Class CCAppleNCyanDark24 : ConsoleColor24 {
    CCAppleNCyanDark24() : base(100, 210, 255) {}
}

Class CCAppleNCyanALight24 : ConsoleColor24 {
    CCAppleNCyanALight24() : base(0, 113, 164) {}
}

Class CCAppleNCyanADark24 : ConsoleColor24 {
    CCAppleNCyanADark24() : base(112, 215, 255) {}
}

Class CCAppleNBlueLight24 : ConsoleColor24 {
    CCAppleNBlueLight24() : base(0, 122, 255) {}
}

Class CCAppleNBlueDark24 : ConsoleColor24 {
    CCAppleNBlueDark24() : base(10, 132, 255) {}
}

Class CCAppleNBlueALight24 : ConsoleColor24 {
    CCAppleNBlueALight24() : base(0, 64, 221) {}
}

Class CCAppleNBlueADark24 : ConsoleColor24 {
    CCAppleNBlueADark24() : base(64, 156, 255) {}
}

Class CCAppleNIndigoLight24 : ConsoleColor24 {
    CCAppleNIndigoLight24() : base(88, 86, 214) {}
}

Class CCAppleNIndigoDark24 : ConsoleColor24 {
    CCAppleNIndigoDark24() : base(94, 92, 230) {}
}

Class CCAppleNIndigoALight24 : ConsoleColor24 {
    CCAppleNIndigoALight24() : base(54, 52, 163) {}
}

Class CCAppleNIndigoADark24 : ConsoleColor24 {
    CCAppleNIndigoADark24() : base(125, 122, 255) {}
}

Class CCAppleNPurpleLight24 : ConsoleColor24 {
    CCAppleNPurpleLight24() : base(175, 82, 222) {}
}

Class CCAppleNPurpleDark24 : ConsoleColor24 {
    CCAppleNPurpleDark24() : base(191, 90, 242) {}
}

Class CCAppleNPurpleALight24 : ConsoleColor24 {
    CCAppleNPurpleALight24() : base(137, 68, 171) {}
}

Class CCApplNPurpleADark24 : ConsoleColor24 {
    CCApplNPurpleADark24() : base(218, 143, 255) {}
}

Class CCAppleNPinkLight24 : ConsoleColor24 {
    CCAppleNPinkLight24() : base(255, 45, 85) {}
}

Class CCAppleNPinkDark24 : ConsoleColor24 {
    CCAppleNPinkDark24() : base(255, 55, 95) {}
}

Class CCAppleNPinkALight24 : ConsoleColor24 {
    CCAppleNPinkALight24() : base(211, 15, 69) {}
}

Class CCAppleNPinkADark24 : ConsoleColor24 {
    CCAppleNPinkADark24() : base(255, 100, 130) {}
}

Class CCAppleNBrownLight24 : ConsoleColor24 {
    CCAppleNBrownLight24() : base(162, 132, 94) {}
}

Class CCAppleNBrownDark24 : ConsoleColor24 {
    CCAppleNBrownDark24() : base(172, 142, 104) {}
}

Class CCAppleNBrownALight24 : ConsoleColor24 {
    CCAppleNBrownALight24() : base(127, 101, 69) {}
}

Class CCAppleNBrownADark24 : ConsoleColor24 {
    CCAppleNBrownADark24() : base(181, 148, 105) {}
}

Class CCAppleNGreyLight24 : ConsoleColor24 {
    CCAppleNGreyLight24() : base(142, 142, 147) {}
}

Class CCAppleNGreyDark24 : ConsoleColor24 {
    CCAppleNGreyDark24() : base(142, 142, 147) {}
}

Class CCAppleNGreyALight24 : ConsoleColor24 {
    CCAppleNGreyALight24() : base(108, 108, 112) {}
}

Class CCAppleNGreyADark24 : ConsoleColor24 {
    CCAppleNGreyADark24() : base(174, 174, 178) {}
}

Class CCAppleNGrey2Light24 : ConsoleColor24 {
    CCAppleNGrey2Light24() : base(174, 174, 178) {}
}

Class CCAppleNGrey2Dark24 : ConsoleColor24 {
    CCAppleNGrey2Dark24() : base(99, 99, 102) {}
}

Class CCAppleNGrey2ALight24 : ConsoleColor24 {
    CCAppleNGrey2ALight24() : base(142, 142, 147) {}
}

Class CCAppleNGrey2ADark24 : ConsoleColor24 {
    CCAppleNGrey2ADark24() : base(124, 124, 128) {}
}

Class CCAppleNGrey3Light24 : ConsoleColor24 {
    CCAppleNGrey3Light24() : base(199, 199, 204) {}
}

Class CCAppleNGrey3Dark24 : ConsoleColor24 {
    CCAppleNGrey3Dark24() : base(72, 72, 74) {}
}

Class CCAppleNGrey4ALight24 : ConsoleColor24 {
    CCAppleNGrey4ALight24() : base(188, 188, 192) {}
}

Class CCAppleNGrey4ADark24 : ConsoleColor24 {
    CCAppleNGrey4ADark24() : base(68, 68, 70) {}
}

Class CCAppleNGrey5Light24 : ConsoleColor24 {
    CCAppleNGrey5Light24() : base(229, 229, 234) {}
}

Class CCAppleNGrey5Dark24 : ConsoleColor24 {
    CCAppleNGrey5Dark24() : base(44, 44, 46) {}
}

Class CCAppleNGrey5ALight24 : ConsoleColor24 {
    CCAppleNGrey5ALight24() : base(216, 216, 220) {}
}

Class CCAppleNGrey5ADark24 : ConsoleColor24 {
    CCAppleNGrey5ADark24() : base(54, 54, 56) {}
}

Class CCAppleNGrey6Light24 : ConsoleColor24 {
    CCAppleNGrey6Light24() : base(242, 242, 247) {}
}

Class CCAppleNGrey6Dark24 : ConsoleColor24 {
    CCAppleNGrey6Dark24() : base(28, 28, 30) {}
}

Class CCAppleNGrey6ALight24 : ConsoleColor24 {
    CCAppleNGrey6ALight24() : base(235, 235, 240) {}
}

Class CCAppleNGrey6ADark24 : ConsoleColor24 {
    CCAppleNGrey6ADark24() : base(36, 36, 38) {}
}

Class CCAppleVRedLight24 : ConsoleColor24 {
    CCAppleVRedLight24() : base(255, 49, 38) {}
}

Class CCAppleVRedDark24 : ConsoleColor24 {
    CCAppleVRedDark24() : base(255, 79, 68) {}
}

Class CCAppleVRedALight24 : ConsoleColor24 {
    CCAppleVRedALight24() : base(194, 6, 24) {}
}

Class CCAppleVRedADark24 : ConsoleColor24 {
    CCAppleVRedADark24() : base(255, 65, 54) {}
}

Class CCAppleVOrangeLight24 : ConsoleColor24 {
    CCAppleVOrangeLight24() : base(245, 139, 0) {}
}

Class CCAppleVOrangeDark24 : ConsoleColor24 {
    CCAppleVOrangeDark24() : base(255, 169, 20) {}
}

Class CCAppleVOrangeALight24 : ConsoleColor24 {
    CCAppleVOrangeALight24() : base(173, 58, 0) {}
}

Class CCAppleVOrangeADark24 : ConsoleColor24 {
    CCAppleVOrangeADark24() : base(255, 179, 64) {}
}

Class CCAppleVYellowLight24 : ConsoleColor24 {
    CCAppleVYellowLight24() : base(245, 194, 0) {}
}

Class CCAppleVYellowDark24 : ConsoleColor24 {
    CCAppleVYellowDark24() : base(255, 224, 20) {}
}

Class CCAppleVYellowALight24 : ConsoleColor24 {
    CCAppleVYellowALight24() : base(146, 81, 0) {}
}

Class CCAppleVYellowADark24 : ConsoleColor24 {
    CCAppleVYellowADark24() : base(255, 212, 38) {}
}

Class CCAppleVGreenLight24 : ConsoleColor24 {
    CCAppleVGreenLight24() : base(30, 195, 55) {}
}

Class CCAppleVGreenDark24 : ConsoleColor24 {
    CCAppleVGreenDark24() : base(60, 225, 85) {}
}

Class CCAppleVGreenALight24 : ConsoleColor24 {
    CCAppleVGreenALight24() : base(0, 112, 24) {}
}

Class CCAppleVGreenADark24 : ConsoleColor24 {
    CCAppleVGreenADark24() : base(49, 222, 75) {}
}

Class CCAppleVMintLight24 : ConsoleColor24 {
    CCAppleVMintLight24() : base(0, 189, 180) {}
}

Class CCAppleVMintDark24 : ConsoleColor24 {
    CCAppleVMintDark24() : base(108, 224, 219) {}
}

Class CCAppleVMintALight24 : ConsoleColor24 {
    CCAppleVMintALight24() : base(11, 117, 112) {}
}

Class CCAppleVMintADark24 : ConsoleColor24 {
    CCAppleVMintADark24() : base(49, 222, 75) {}
}

Class CCAppleVTealLight24 : ConsoleColor24 {
    CCAppleVTealLight24() : base(46, 167, 189) {}
}

Class CCAppleVTealDark24 : ConsoleColor24 {
    CCAppleVTealDark24() : base(68, 212, 237) {}
}

Class CCAppleVTealALight24 : ConsoleColor24 {
    CCAppleVTealALight24() : base(0, 119, 140) {}
}

Class CCAppleVTealADark24 : ConsoleColor24 {
    CCAppleVTealADark24() : base(93, 230, 255) {}
}

Class CCAppleVCyanLight24 : ConsoleColor24 {
    CCAppleVCyanLight24() : base(65, 175, 220) {}
}

Class CCAppleVCyanDark24 : ConsoleColor24 {
    CCAppleVCyanDark24() : base(90, 205, 250) {}
}

Class CCAppleVCyanALight24 : ConsoleColor24 {
    CCAppleVCyanALight24() : base(0, 103, 150) {}
}

Class CCAppleVCyanADark24 : ConsoleColor24 {
    CCAppleVCyanADark24() : base(112, 215, 255) {}
}

Class CCAppleVBlueLight24 : ConsoleColor24 {
    CCAppleVBlueLight24() : base(0, 122, 245) {}
}

Class CCAppleVBlueDark24 : ConsoleColor24 {
    CCAppleVBlueDark24() : base(20, 142, 255) {}
}

Class CCAppleVBlueALight24 : ConsoleColor24 {
    CCAppleVBlueALight24() : base(0, 64, 221) {}
}

Class CCAppleVBlueADark24 : ConsoleColor24 {
    CCAppleVBlueADark24() : base(64, 156, 255) {}
}

Class CCAppleVIndigoLight24 : ConsoleColor24 {
    CCAppleVIndigoLight24() : base(84, 82, 204) {}
}

Class CCAppleVIndigoDark24 : ConsoleColor24 {
    CCAppleVIndigoDark24() : base(99, 97, 242) {}
}

Class CCAppleVIndigoALight24 : ConsoleColor24 {
    CCAppleVIndigoALight24() : base(54, 52, 163) {}
}

Class CCAppleVIndigoADark24 : ConsoleColor24 {
    CCAppleVIndigoADark24() : base(125, 122, 255) {}
}

Class CCAppleVPurpleLight24 : ConsoleColor24 {
    CCAppleVPurpleLight24() : base(159, 75, 201) {}
}

Class CCAppleVPurpleDark24 : ConsoleColor24 {
    CCAppleVPurpleDark24() : base(204, 101, 255) {}
}

Class CCAppleVPurpleALight24 : ConsoleColor24 {
    CCAppleVPurpleALight24() : base(173, 68, 171) {}
}

Class CCAppleVPurpleADark24 : ConsoleColor24 {
    CCAppleVPurpleADark24() : base(218, 143, 255) {}
}

Class CCAppleVPinkLight24 : ConsoleColor24 {
    CCAppleVPinkLight24() : base(245, 35, 75) {}
}

Class CCAppleVPinkDark24 : ConsoleColor24 {
    CCAppleVPinkDark24() : base(255, 65, 105) {}
}

Class CCAppleVPinkALight24 : ConsoleColor24 {
    CCAppleVPinkALight24() : base(193, 16, 50) {}
}

Class CCAppleVPinkADark24 : ConsoleColor24 {
    CCAppleVPinkADark24() : base(255, 58, 95) {}
}

Class CCAppleVBrownLight24 : ConsoleColor24 {
    CCAppleVBrownLight24() : base(152, 122, 84) {}
}

Class CCAppleVBrownDark24 : ConsoleColor24 {
    CCAppleVBrownDark24() : base(182, 152, 114) {}
}

Class CCAppleVBrownALight24 : ConsoleColor24 {
    CCAppleVBrownALight24() : base(119, 93, 59) {}
}

Class CCAppleVGreyLight24 : ConsoleColor24 {
    CCAppleVGreyLight24() : base(132, 132, 137) {}
}

Class CCAppleVGreyDark24 : ConsoleColor24 {
    CCAppleVGreyDark24() : base(162, 162, 167) {}
}

Class CCAppleVGreyALight24 : ConsoleColor24 {
    CCAppleVGreyALight24() : base(97, 97, 101) {}
}

Class CCAppleVGreyADark24 : ConsoleColor24 {
    CCAppleVGreyADark24() : base(152, 152, 157) {}
}

Class CCTextDefault24 : CCAppleNGrey5Light24 {
}

Class CCListItemCurrentHighlight24 : CCAppleNPinkLight24 {
}

Class CCChevronActive24 : CCAppleNGreenLight24 {
}

Class CCChevronInactive24 : CCAppleNOrangeLight24 {
}

Class ATControlSequences {
    Static [String]$ForegroundColor24Prefix   = "`e[38;2;"
    Static [String]$BackgroundColor24Prefix   = "`e[48;2;"
    Static [String]$ModifierReset             = "`e[0m"
    Static [String]$DecorationBold            = "`e[1m"
    Static [String]$DecorationItalic          = "`e[3m"
    Static [String]$DecorationUnderline       = "`e[4m"
    Static [String]$DecorationBlink           = "`e[5m"
    Static [String]$DecorationVideoInvert     = "`e[7m"
    Static [String]$DecorationStrikethru      = "`e[9m"
    Static [String]$DecorationDoubleUnderline = "`e[21m"
    Static [String]$CursorHide                = "`e[?25l"
    Static [String]$CursorShow                = "`e[?25h"

    Static [String]GenerateFG24String([ConsoleColor24]$Color) {
        Return "$([ATControlSequences]::ForegroundColor24Prefix)$($Color.Red.ToString());$($Color.Green.ToString());$($Color.Blue.ToString())m"
    }

    Static [String]GenerateBG24String([ConsoleColor24]$Color) {
        Return "$([ATControlSequences]::BackgroundColor24Prefix)$($Color.Red.ToString());$($Color.Green.ToString());$($Color.Blue.ToString())m"
    }

    Static [String]GenerateCoordinateString([Int]$Row, [Int]$Column) {
        Return "`e[$($Row.ToString());$($Column.ToString())H"
    }
}

Class ATForegroundColor24 {
    [ValidateNotNullOrEmpty()][ConsoleColor24]$Color

    ATForegroundColor24(
        [ConsoleColor24]$Color
    ) {
        $this.Color = $Color
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateFG24String($this.Color)
    }
}

Class ATBackgroundColor24 {
    [ValidateNotNullOrEmpty()][ConsoleColor24]$Color

    ATBackgroundColor24(
        [ConsoleColor24]$Color
    ) {
        $this.Color = $Color
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateBG24String($this.Color)
    }
}

Class ATForegroundColor24None : ATForegroundColor24 {
    ATForegroundColor24None() : base([CCBlack24]::new()) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATBackgroundColor24None : ATBackgroundColor24 {
    ATBackgroundColor24None() : base([CCBlack24]::new()) {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATDecoration {
    [Boolean]$Bold
    [Boolean]$Italic
    [Boolean]$Underline
    [Boolean]$Blink
    [Boolean]$VideoInvert
    [Boolean]$Strikethru
    [Boolean]$DoubleUnderline

    ATDecoration() {
        $this.Bold            = $false
        $this.Italic          = $false
        $this.Underline       = $false
        $this.Blink           = $false
        $this.VideoInvert     = $false
        $this.Strikethru      = $false
        $this.DoubleUnderline = $false
    }

    ATDecoration(
        [ATDecoration]$CopyFrom
    ) {
        $this.Bold            = $CopyFrom.Bold
        $this.Italic          = $CopyFrom.Italic
        $this.Underline       = $CopyFrom.Underline
        $this.Blink           = $CopyFrom.Blink
        $this.VideoInvert     = $CopyFrom.VideoInvert
        $this.Strikethru      = $CopyFrom.Strikethru
        $this.DoubleUnderline = $CopyFrom.DoubleUnderline
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        If($this.Underline -EQ $true -AND $this.DoubleUnderline -EQ $true) {
            $this.DoubleUnderline = $false
        }

        If($this.Bold -EQ $true) {
            $a += "$([ATControlSequences]::DecorationBold)"
        }
        If($this.Italic -EQ $true) {
            $a += "$([ATControlSequences]::DecorationItalic)"
        }
        If($this.Underline -EQ $true) {
            $a += "$([ATControlSequences]::DecorationUnderline)"
        }
        If($this.Blink -EQ $true) {
            $a += "$([ATControlSequences]::DecorationBlink)"
        }
        If($this.VideoInvert -EQ $true) {
            $a += "$([ATControlSequences]::DecorationVideoInvert)"
        }
        If($this.Strikethru -EQ $true) {
            $a += "$([ATControlSequences]::DecorationStrikethru)"
        }
        If($this.DoubleUnderline -EQ $true) {
            $a += "$([ATControlSequences]::DecorationDoubleUnderline)"
        }

        Return $a
    }
}

Class ATDecorationNone : ATDecoration {
    ATDecorationNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATCoordinates {
    [ValidateRange(1, 100)][Int]$Row
    [ValidateRange(1, 100)][Int]$Column

    ATCoordinates() {
        $this.Row    = 1
        $this.Column = 1
    }

    ATCoordinates(
        [Coordinates]$AutomationCoordinates
    ) {
        $this.Row    = $AutomationCoordinates.X
        $this.Column = $AutomationCoordinates.Y
    }

    ATCoordinates(
        [ATCoordinates]$CopyFrom
    ) {
        $this.Row    = $CopyFrom.Row
        $this.Column = $CopyFrom.Column
    }

    [String]ToAnsiControlSequenceString() {
        Return [ATControlSequences]::GenerateCoordinateString($this.Row, $this.Column)
    }

    [Coordinates]ToAutomationCoordinates() {
        Return [Coordinates]::new($this.Row, $this.Column)
    }
}

Class ATCoordinatesNone : ATCoordinates {
    ATCoordinatesNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATCoordinatesDefault : ATCoordinates {
    ATCoordinatesDefault() : base() {}
}

Class ATStringPrefix {
    [ATForegroundColor24]$ForegroundColor
    [ATBackgroundColor24]$BackgroundColor
    [ATDecoration]$Decorations
    [ATCoordinates]$Coordinates

    ATStringPrefix() {
        $this.ForegroundColor = [ATForegroundColor24None]::new()
        $this.BackgroundColor = [ATBackgroundColor24None]::new()
        $this.Decorations     = [ATDecorationNone]::new()
        $this.Coordinates     = [ATCoordinatesNone]::new()
    }

    ATStringPrefix(
        [ATStringPrefix]$CopyFrom
    ) {
        $this.ForegroundColor = $CopyFrom.ForegroundColor
        $this.BackgroundColor = $CopyFrom.BackgroundColor
        $this.Decorations     = $CopyFrom.Decorations
        $this.Coordinates     = $CopyFrom.Coordinates
    }

    [String]ToAnsiControlSequenceString() {
        Return "$($this.Coordinates.ToAnsiControlSequenceString())$($this.Decorations.ToAnsiControlSequenceString())$($this.ForegroundColor.ToAnsiControlSequenceString())$($this.BackgroundColor.ToAnsiControlSequenceString())"
    }
}

Class ATStringPrefixNone : ATStringPrefix {
    ATStringPrefixNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATString {
    [ATStringPrefix]$Prefix
    [String]$UserData
    [Boolean]$UseATReset

    ATString() {
        $this.Prefix     = [ATStringPrefixNone]::new()
        $this.UserData   = ''
        $this.UseATReset = $false
    }

    ATString(
        [ATString]$CopyFrom
    ) {
        $this.Prefix     = $CopyFrom.Prefix
        $this.UseATReset = $CopyFrom.UseATReset
        $this.UserData   = $CopyFrom.UserData
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = "$($this.Prefix.ToAnsiControlSequenceString())$($this.UserData)"

        If($this.UseATReset -EQ $true) {
            $a += "$([ATControlSequences]::ModifierReset)"
        }

        Return $a
    }
}

Class ATStringNone : ATString {
    ATStringNone() : base() {}

    [String]ToAnsiControlSequenceString() {
        Return ''
    }
}

Class ATStringComposite {
    [ATString[]]$CompositeActual

    ATStringComposite() {
        $this.CompositeActual = [ATString[]]::new()
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        Foreach($b in $this.CompositeActual) {
            $a += "$($b.ToAnsiControlSequenceString())"
        }

        Return $a
    }
}

[Boolean]                  $Script:UseSfx              = $true
[ProgramState]             $Script:GlobalState         = [ProgramState]::CanvasTypeSelection
[ProgramCore]              $Script:TheProgram          = [ProgramCore]::new()
[CanvasTypeSelectionWindow]$Script:TheCanvasTypeWindow = $null

$Script:Rui             = $(Get-Host).UI.RawUI
$Script:StateBlockTable = @{
    [ProgramState]::CanvasTypeSelection = {
        If ($null -EQ $Script:TheCanvasTypeWindow) {
            Try {
                $Script:TheCanvasTypeWindow = [CanvasTypeSelectionWindow]::new()
            } Catch {
                Write-Host $_
                Exit
            }
        }

        $Script:TheCanvasTypeWindow.Draw()

        # TEST CODE
        $Script:Rui.CursorPosition = ([ATCoordinatesDefault]::new()).ToAutomationCoordinates()

        # $Script:TheCanvasTypeWindow.HandleInput()
    }

    [ProgramState]::ColorSelection = {}

    [ProgramState]::CanvasPaint = {}
}

Class WindowBase {
    Static [Int]$BorderDrawColorTop    = 0
    Static [Int]$BorderDrawColorBottom = 1
    Static [Int]$BorderDrawColorLeft   = 2
    Static [Int]$BorderDrawColorRight  = 3
    Static [Int]$BorderDirtyTop        = 0
    Static [Int]$BorderDirtyBottom     = 1
    Static [Int]$BorderDirtyLeft       = 2
    Static [Int]$BorderDirtyRight      = 3
    Static [Int]$BorderStringTop       = 0
    Static [Int]$BorderStringBottom    = 1
    Static [Int]$BorderStringLeft      = 2
    Static [Int]$BorderStringRight     = 3

    [ATCoordinates]$LeftTop
    [ATCoordinates]$RightBottom
    [ConsoleColor24[]]$BorderDrawColors
    [String[]]$BorderStrings
    [Boolean[]]$BorderDrawDirty
    [Int]$Width
    [Int]$Height

    WindowBase() {
        $this.LeftTop          = [ATCoordinatesNone]::new()
        $this.RightBottom      = [ATCoordinatesNone]::new()
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCBlack24]::new(),
            [CCBlack24]::new(),
            [CCBlack24]::new(),
            [CCBlack24]::new()
        )
        $this.BorderStrings = [String[]](
            '',
            '',
            '',
            ''
        )
        $this.BorderDrawDirty = [Boolean[]](
            $true,
            $true,
            $true,
            $true
        )
        $this.UpdateDimensions()
    }

    WindowBase(
        [ATCoordinates]$LeftTop,
        [ATCoordinates]$RightBottom,
        [ConsoleColor24[]]$BorderDrawColors,
        [String[]]$BorderStrings,
        [Boolean[]]$BorderDrawDirty
    ) {
        $this.LeftTop          = $LeftTop
        $this.RightBottom      = $RightBottom
        $this.BorderDrawColors = $BorderDrawColors
        $this.BorderStrings    = $BorderStrings
        $this.BorderDrawDirty  = $BorderDrawDirty
        $this.UpdateDimensions()
    }

    [Void]Draw() {
        [ATString]$bt = [ATStringNone]::new()
        [ATString]$bb = [ATStringNone]::new()
        [ATString]$bl = [ATStringNone]::new()
        [ATString]$br = [ATStringNone]::new()

        If($this.BorderDrawDirty[[WindowBase]::BorderDirtyTop] -EQ $true) {
            $bt = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $this.BorderDrawColors[[WindowBase]::BorderDrawColorTop]
                    Coordinates     = $this.LeftTop
                }
                UserData = "$($this.BorderStrings[[WindowBase]::BorderStringTop])"
            }
            $this.BorderDrawDirty[[WindowBase]::BorderDirtyTop] = $false
        }
        If($this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom] -EQ $true) {
            $bb = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $this.BorderDrawColors[[WindowBase]::BorderDrawColorBottom]
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.RightBottom.Row
                        Column = $this.LeftTop.Column
                    }
                }
                UserData = "$($this.BorderStrings[[WindowBase]::BorderStringBottom])"
            }
            $this.BorderDrawDirty[[WindowBase]::BorderDirtyBottom] = $false
        }
        If($this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft] -EQ $true) {
            $bl = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $this.BorderDrawColors[[WindowBase]::BorderDrawColorLeft]
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 1
                        Column = $this.LeftTop.Column
                    }
                }
                UserData = $(
                    Invoke-Command -ScriptBlock {
                        [String]$temp = ''

                        For($a = 0; $a -LT $this.Height; $a++) {
                            [ATCoordinates]$b = [ATCoordinates]@{
                                Row    = ($this.LeftTop.Row + 1) + $a
                                Column = $this.LeftTop.Column
                            }
                            $temp += "$($this.BorderStrings[[WindowBase]::BorderStringLeft])$($b.ToAnsiControlSequenceString())"
                        }

                        Return $temp
                    }
                )
            }
            $this.BorderDrawDirty[[WindowBase]::BorderDirtyLeft] = $false
        }
        If($this.BorderDrawDirty[[WindowBase]::BorderDirtyRight] -EQ $true) {
            $br = [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = $this.BorderDrawColors[[WindowBase]::BorderDrawColorRight]
                    Coordinates     = [ATCoordinates]@{
                        Row    = $this.LeftTop.Row + 1
                        Column = $this.RightBottom.Column + 1
                    }
                }
                UserData = $(
                    Invoke-Command -ScriptBlock {
                        [String]$temp = ''

                        For($a = 0; $a -LT $this.Height; $a++) {
                            [ATCoordinates]$b = [ATCoordinates]@{
                                Row    = ($this.LeftTop.Row + 1) + $a
                                Column = $this.RightBottom.Column + 1
                            }
                            $temp += "$($this.BorderStrings[[WindowBase]::BorderStringRight])$($b.ToAnsiControlSequenceString())"
                        }

                        Return $temp
                    }
                )
            }
            $this.BorderDrawDirty[[WindowBase]::BorderDirtyRight] = $false
        }

        Write-Host "$($bt.ToAnsiControlSequenceString())$($bb.ToAnsiControlSequenceString())$($bl.ToAnsiControlSequenceString())$($br.ToAnsiControlSequenceString())"
    }

    [Void]UpdateDimensions() {
        $this.Width  = $this.RightBottom.Column - $this.LeftTop.Column
        $this.Height = $this.RightBottom.Row - $this.LeftTop.Row
    }
}

Class CanvasTypeSelectionWindow : WindowBase {
    Static [Int]$LineCompositeChevronA     = 0
    Static [Int]$LineCompositeLabelA       = 1
    Static [Int]$LineCompositeChevronB     = 2
    Static [Int]$LineCompositeLabelB       = 3
    Static [Int]$WindowLTRow               = 1
    Static [Int]$WindowLTColumn            = 1
    Static [Int]$WindowRBRow               = 5
    Static [Int]$WindowRBColumn            = 20
    Static [String]$ChevronCharacterActual = "`u{25B7}"
    Static [String]$ChevronBlankActual     = ' '
    Static [String]$LineBlankActual        = '                  '
    Static [String]$OptionALabel           = 'Scene'
    Static [String]$OptionBLabel           = 'Enemy'
    Static [String]$WindowBorderTopStr     = "`u{2767}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2619}"
    Static [String]$WindowBorderBottomStr  = "`u{2767}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2026}`u{2619}"
    Static [String]$WindowBorderLeftStr    = "`u{23A8}"
    Static [String]$WindowBorderRightStr   = "`u{23AC}"

    Static [ATString]$LineBlank = [ATString]@{
        Prefix = [ATStringPrefix]@{
            BackgroundColor = [CCBlack24]::new()
            ForegroundColor = [CCBlack24]::new()
        }
        UserData   = [CanvasTypeSelectionWindow]::LineBlankActual
        UseATReset = $true
    }
    Static [ATString]$OptionAActual = [ATString]@{
        Prefix = [ATStringPrefix]@{
            BackgroundColor = [CCBlack24]::new()
            ForegroundColor = [CCBlack24]::new()
        }
        UserData   = [CanvasTypeSelectionWindow]::OptionALabel
        UseATReset = $true
    }
    Static [ATString]$OptionBActual = [ATString]@{
        Prefix = [ATStringPrefix]@{
            BackgroundColor = [CCBlack24]::new()
            ForegroundColor = [CCBlack24]::new()
        }
        UserData   = [CanvasTypeSelectionWindow]::OptionBLabel
        UseATReset = $true
    }

    [Boolean]$LineDirty
    [List[ValueTuple[[ATString], [Boolean]]]]$ChevronList
    [Int]$ActiveChevronIndex
    [ATCoordinates]$OptionALabelDrawCoordinates
    [ATCoordinates]$OptionBLabelDrawCoordinates
    [ATStringComposite]$LineComposite

    CanvasTypeSelectionWindow() : base() {
        $this.LeftTop = [ATCoordinates]@{
            Row    = [CanvasTypeSelectionWindow]::WindowLTRow
            Column = [CanvasTypeSelectionWindow]::WindowLTColumn
        }
        $this.RightBottom = [ATCoordinates]@{
            Row    = [CanvasTypeSelectionWindow]::WindowRBRow
            Column = [CanvasTypeSelectionWindow]::WindowRBColumn
        }
        $this.BorderDrawColors = [ConsoleColor24[]](
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new(),
            [CCWhite24]::new()
        )
        $this.BorderStrings = [String[]](
            [CanvasTypeSelectionWindow]::WindowBorderTopStr,
            [CanvasTypeSelectionWindow]::WindowBorderBottomStr,
            [CanvasTypeSelectionWindow]::WindowBorderLeftStr,
            [CanvasTypeSelectionWindow]::WindowBorderRightStr
        )
        $this.UpdateDimensions()
        $this.Initialize()
    }

    [Void]Initialize() {
        $this.LineDirty                   = $true
        $this.ActiveChevronIndex          = 0
        $this.OptionALabelDrawCoordinates = [ATCoordinates]@{
            Row    = 3
            Column = 5
        }
        $this.OptionBLabelDrawCoordinates = [ATCoordinates]@{
            Row    = 3
            Column = 14
        }
        $this.CreateChevrons()
    }

    [Void]CreateChevrons() {
        $this.ChevronList = [List[ValueTuple[[ATString], [Boolean]]]]::new()
        $this.ChevronList.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleNGreenALight24]::new()
                        Decorations     = [ATDecoration]@{
                            Bold  = $true
                            Blink = $true
                        }
                        Coordinates = [ATCoordinates]@{
                            Row    = $this.OptionALabelDrawCoordinates.Row
                            Column = $this.OptionALabelDrawCoordinates.Column - 2
                        }
                    }
                },
                $true
            )
        )
        $this.ChevronList.Add(
            [ValueTuple]::Create(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleNGreenALight24]::new()
                        Decorations     = [ATDecoration]@{
                            Bold  = $true
                            Blink = $true
                        }
                        Coordinates = [ATCoordinates]@{
                            Row    = $this.OptionBLabelDrawCoordinates.Row
                            Column = $this.OptionBLabelDrawCoordinates.Column - 2
                        }
                    }
                },
                $true
            )
        )
    }

    [Void]CreateTextLine() {
        $this.LineComposite = [ATStringComposite]::new()
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()
    }
}

Class ProgramCore {
    [Boolean]$Running
    
    ProgramCore() {
        $this.Running = $true
    }

    [Void]Run() {
        While ($this.Running -EQ $true) {
            $this.Logic()
        }
    }

    [Void]Logic() {
        Invoke-Command $Script:StateBlockTable[$Script:GlobalState]
        $Script:Rui.FlushInputBuffer()
    }
}

Clear-Host
$Script:TheProgram.Run()