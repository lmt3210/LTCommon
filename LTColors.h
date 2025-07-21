// 
// LTColors.h
//
// Copyright (c) 2020-2025 Larry M. Taylor
//
// This software is provided 'as-is', without any express or implied
// warranty. In no event will the authors be held liable for any damages
// arising from the use of this software. Permission is granted to anyone to
// use this software for any purpose, including commercial applications, and to
// to alter it and redistribute it freely, subject to 
// the following restrictions:
//
// 1. The origin of this software must not be misrepresented; you must not
//    claim that you wrote the original software. If you use this software
//    in a product, an acknowledgment in the product documentation would be
//    appreciated but is not required.
// 2. Altered source versions must be plainly marked as such, and must not be
//    misrepresented as being the original software.
// 3. This notice may not be removed or altered from any source
//    distribution.
//

struct colorTable
{
    NSString *name;
    unsigned int rgb;
};

const struct colorTable colorList[] =
{
    { @"Black", 0x000000 },
    { @"Alice Blue", 0xf0f8ff },
    { @"Aqua", 0x00ffff },
    { @"Aquamarine", 0x7fffd4 },
    { @"Azure", 0xf0ffff },
    { @"Blue", 0x0000ff },
    { @"Blue Violet", 0x8a2be2 },
    { @"Brown", 0xa52a2a },
    { @"Burlywood", 0xdeb887 },
    { @"Cadet Blue", 0x5f9ea0 },
    { @"Chartreuse", 0x7fff00 },
    { @"Chocolate", 0xd2691e },
    { @"Coral", 0xff7f50 },
    { @"Cornflower Blue", 0x6495ed },
    { @"Cornsilk", 0xfff8dc },
    { @"Crimson", 0xdc143c },
    { @"Cyan", 0x00ffff },
    { @"Dark Blue", 0x00008b },
    { @"Dark Cyan", 0x008b8b },
    { @"Dark Goldenrod", 0xb8860b },
    { @"Dark Green", 0x006400 },
    { @"Dark Magenta", 0x8b008b },
    { @"Dark Orange", 0xff8c00 },
    { @"Dark Orchid", 0x9932cc },
    { @"Dark Red", 0x8b0000 },
    { @"Dark Salmon", 0xe9967a },
    { @"Dark Sea Green", 0x8fbc8f },
    { @"Dark Slate Blue", 0x483d8b },
    { @"Dark Turquoise", 0x00ced1 },
    { @"Dark Violet", 0x9400d3 },
    { @"Deep Pink", 0xff1493 },
    { @"Deep Sky Blue", 0x00bfff },
    { @"Dodger Blue", 0x1e90ff },
    { @"Forest Green", 0x228b22 },
    { @"Fuchsia", 0xff00ff },
    { @"Gold", 0xffd700 },
    { @"Goldenrod", 0xdaa520 },
    { @"Green", 0x00ff00 },
    { @"Hot Pink", 0xff69b4 },
    { @"Indigo", 0x4b0082 },
    { @"Ivory", 0xfffff0 },
    { @"Khaki", 0xf0e68c },
    { @"Lavender", 0xe6e6fa },
    { @"Lawn Green", 0x7cfc00 },
    { @"Light Blue", 0xadd8e6 },
    { @"Light Coral", 0xf08080 },
    { @"Light Cyan", 0xe0ffff },
    { @"Light Green", 0x90ee90 },
    { @"Light Pink", 0xffb6c1 },
    { @"Light Salmon", 0xffa07a },
    { @"Light Sea Green", 0x20b2aa },
    { @"Light Sky Blue", 0x87cefa },
    { @"Light Steel Blue", 0xb0c4de },
    { @"Light Yellow", 0xffffe0 },
    { @"Lime", 0x00ff00 },
    { @"Lime Green", 0x32cd32 },
    { @"Magenta", 0xff00ff },
    { @"Maroon", 0x800000 },
    { @"Medium Aquamarine", 0x66cdaa },
    { @"Medium Blue", 0x0000cd },
    { @"Medium Purple", 0x9370db },
    { @"Medium Sea Green", 0x3cb371 },
    { @"Medium Slate Blue", 0x7b68ee },
    { @"Medium Spring Green", 0x00fa9a },
    { @"Medium Turquoise", 0x48d1cc },
    { @"Medium Violet Red", 0xc71585 },
    { @"Midnight Blue", 0x191970 },
    { @"Misty Rose", 0xffe4e1 },
    { @"Moccasin", 0xffe4b5 },
    { @"Navy", 0x000080 },
    { @"Olive", 0x808000 },
    { @"Orange", 0xffa500 },
    { @"Orange Red", 0xff4500 },
    { @"Peru", 0xcd853f },
    { @"Pink", 0xffc0cb },
    { @"Plum", 0xdda0dd },
    { @"Powder Blue", 0xb0e0e6 },
    { @"Purple", 0x800080 },
    { @"Red", 0xff0000 },
    { @"Rosy Brown", 0xbc8f8f },
    { @"Royal Blue", 0x4169e1 },
    { @"Saddle Brown", 0x8b4513 },
    { @"Salmon", 0xfa8072 },
    { @"Sandy Brown", 0xf4a460 },
    { @"Sea Green", 0x2e8b57 },
    { @"Seashell", 0xfff5ee },
    { @"Sienna", 0xa0522d },
    { @"Silver", 0xc0c0c0 },
    { @"Sky Blue", 0x87ceeb },
    { @"Slate Blue", 0x6a5acd },
    { @"Spring Green", 0x00ff7f },
    { @"Steel Blue", 0x4682b4 },
    { @"Teal", 0x008080 },
    { @"Thistle", 0xd8bfd8 },
    { @"Tomato", 0xff6347 },
    { @"Turquoise", 0x40e0d0 },
    { @"Violet", 0xee82ee },
    { @"Wheat", 0xf5deb3 },
    { @"White", 0xffffff },
    { @"Yellow", 0xffff00 }
};
