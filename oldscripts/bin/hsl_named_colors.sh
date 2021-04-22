#!/bin/sh
#
# hsl_named_colors [output_image]
#
# Convert all named colors known by IM into three HSL colorwheels
# Off-Whites,  Mid-Tones,  and  Dark Colors.
#

(
  # Draw a gradient line for the HSL axis. (offset by color spot center)
  convert -size 1x251 -page +116+3 gradient:black-white miff:-

  # Draw the color axis for main disk
  convert -size 221x121 -page +6+68 xc:none \
          -draw 'fill Red      line 110,60 220,60' \
          -draw 'fill Cyan     line 110,60   0,60' \
          -draw 'fill Blue     line 110,60  33,0' \
          -draw 'fill Lime     line 110,60  33,120' \
          -draw 'fill Magenta  line 110,60 187,0' \
          -draw 'fill Yellow   line 110,60 187,120' \
          miff:-

  # Read known named colors, with only numbered greys.
  convert -list color |
    sed '/^\(Path\|Name\|----\)/d;
        /[a-z] [a-z]/d;     # color with space in name! - Yuck
        s/ .*//; /^$/d' |

        # don't output colors containing numbers
        #s/ .*//; /^$/d; /[0-9]/d' |

        # output 10% gray color scale too.
        #s/ .*//; /^$/d; /^gray[0-9]*0$/p; /[0-9]/d' |

  # reverse order so most common is given last
  tac |

  # convert named color into a positions spot of color
  while read color
  do
    # Ignore some specific colors (remove black spot in dark colors)
    case $color in
      transparent|none)     continue ;;   # transparent colors
      matte|opaque|fractal) continue ;;   # opaque colors
      grey*)                continue ;;   # percentage greys
    esac

    # Now convert the named color to HSL color space color
    hsl=`convert xc:$color -colorspace HSL -depth 16 txt: |
          sed '1d; s/^.*: (//; s/).*//; s/,/ /g;' `

    # Luminance  or how bright the color is...
    # Separate colors into three groups  Off White, Dark, Midtone
    # Make the saturation radius of dark and light colors smaller.
    lum=`echo $hsl | awk '{print int($3/65536*100)}'` # percentage
    if   [ $lum -lt 40 ]; then lum=40   radius=50     # dark colorwheel
    elif [ $lum -gt 80 ]; then lum=210  radius=50     # off-white colorwheel
                          else lum=125  radius=100    # midtone colorwheel
    fi

    # Saturation determines the radius.
    # Spread out midtones to cover more of the color wheel
    sat=`echo $hsl | awk '{print $2/65536*'$radius'}'`

    # Greyscale colors leave luminance as is, so as to for a (HSL Axis)
    case $color in
    #grey*|
    white|black)
        lum=`echo $hsl | awk '{print int($3/65536*250)}'` ;;
    esac

    # Hue in degrees
    hue=`echo $hsl | awk '{print $1/65536*360}'`

    # determine X,Y coordinates of this color in chart
    x=`identify -format "%[fx:int( $sat*cos($hue*pi/180)     + 110 )]" xc:`
    y=`identify -format "%[fx:int( $sat*sin($hue*pi/180)/2.2 +$lum )]" xc:`

    # For Debugging
    # output the color and final position
    #awk >&2 'BEGIN{printf("%-20s  %6.2f,%4.1f,%2s   %3s,%s\n",
    #               '"\"$color\", $hue,$sat,$lum, $x,$y) }"

    # Now generate a color spot in three color wheels using these values.
    convert -size 13x7 -page "+$x+$y" xc:none \
            -draw "fill $color arc 0,0 12,6 0,360"  miff:-

  done

  # Redraw parts of axis that is in foreground (over color spots)
  convert -size 1x251 -page +116+3 gradient:black-white \
          \( xc:none -draw 'line 0,40 0,70' \
                     -draw 'line 0,125 0,180' \
                     -draw 'line 0,210 0,240' \
          \) -alpha set -compose DstIn -composite miff:-

) |
# Just a montage of all color in alphabetical order
#montage MIFF:- +repage -background none -geometry +2+2 show:; exit

# read positioned color spots, and merge together
convert -background Gray45   MIFF:-  -layers merge +repage \
        -bordercolor Gray45 -border 10 -flip "${1:-"show:"}"


