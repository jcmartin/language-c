{-# OPTIONS  #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Language.C.Parser.Tokens
-- Copyright   :  [1999..2004] Manuel M T Chakravarty
--                2005 Duncan Coutts
-- License     :  BSD-style
-- Maintainer  :  benedikt.huber@gmail.com
-- Portability :  portable
--
--  C Tokens for the C lexer.
--
-----------------------------------------------------------------------------
module Language.C.Parser.Tokens (CToken(..), posLenOfTok, GnuCTok(..), ClangCTok(..)) where

import Language.C.Data.Position    (Position, Pos(..), PosLength)
import Language.C.Data.Ident       (Ident, identToString)
import Language.C.Syntax.Constants (CChar, CInteger, CFloat, CString, ClangCVersion)

-- token definition
-- ----------------

-- possible tokens (EXPORTED)
--
data CToken = CTokLParen   !PosLength            -- `('
            | CTokRParen   !PosLength            -- `)'
            | CTokLBracket !PosLength            -- `['
            | CTokRBracket !PosLength            -- `]'
            | CTokArrow    !PosLength            -- `->'
            | CTokDot      !PosLength            -- `.'
            | CTokExclam   !PosLength            -- `!'
            | CTokTilde    !PosLength            -- `~'
            | CTokInc      !PosLength            -- `++'
            | CTokDec      !PosLength            -- `--'
            | CTokPlus     !PosLength            -- `+'
            | CTokMinus    !PosLength            -- `-'
            | CTokStar     !PosLength            -- `*'
            | CTokSlash    !PosLength            -- `/'
            | CTokPercent  !PosLength            -- `%'
            | CTokAmper    !PosLength            -- `&'
            | CTokShiftL   !PosLength            -- `<<'
            | CTokShiftR   !PosLength            -- `>>'
            | CTokLess     !PosLength            -- `<'
            | CTokLessEq   !PosLength            -- `<='
            | CTokHigh     !PosLength            -- `>'
            | CTokHighEq   !PosLength            -- `>='
            | CTokEqual    !PosLength            -- `=='
            | CTokUnequal  !PosLength            -- `!='
            | CTokHat      !PosLength            -- `^'
            | CTokBar      !PosLength            -- `|'
            | CTokAnd      !PosLength            -- `&&'
            | CTokOr       !PosLength            -- `||'
            | CTokQuest    !PosLength            -- `?'
            | CTokColon    !PosLength            -- `:'
            | CTokAssign   !PosLength            -- `='
            | CTokPlusAss  !PosLength            -- `+='
            | CTokMinusAss !PosLength            -- `-='
            | CTokStarAss  !PosLength            -- `*='
            | CTokSlashAss !PosLength            -- `/='
            | CTokPercAss  !PosLength            -- `%='
            | CTokAmpAss   !PosLength            -- `&='
            | CTokHatAss   !PosLength            -- `^='
            | CTokBarAss   !PosLength            -- `|='
            | CTokSLAss    !PosLength            -- `<<='
            | CTokSRAss    !PosLength            -- `>>='
            | CTokComma    !PosLength            -- `,'
            | CTokSemic    !PosLength            -- `;'
            | CTokLBrace   !PosLength            -- `{'
            | CTokRBrace   !PosLength            -- `}'
            | CTokEllipsis !PosLength            -- `...'
            | CTokAlignof  !PosLength            -- `alignof'
                                                -- (or `__alignof',
                                                -- `__alignof__')
            | CTokAlignas  !PosLength            -- `_Alignas'
            | CTokAsm      !PosLength            -- `asm'
                                                -- (or `__asm',
                                                -- `__asm__')
            | CTokAtomic   !PosLength            -- `_Atomic'
            | CTokAuto     !PosLength            -- `auto'
            | CTokBreak    !PosLength            -- `break'
            | CTokBool     !PosLength            -- `_Bool'
            | CTokCase     !PosLength            -- `case'
            | CTokChar     !PosLength            -- `char'
            | CTokConst    !PosLength            -- `const'
                                                -- (or `__const', `__const__')
            | CTokContinue !PosLength            -- `continue'
            | CTokComplex  !PosLength            -- `_Complex'
            | CTokDefault  !PosLength            -- `default'
            | CTokDo       !PosLength            -- `do'
            | CTokDouble   !PosLength            -- `double'
            | CTokElse     !PosLength            -- `else'
            | CTokEnum     !PosLength            -- `enum'
            | CTokExtern   !PosLength            -- `extern'
            | CTokFloat    !PosLength            -- `float'
            | CTokBFloat16 !PosLength            -- `__bf16'
            | CTokFloatN !Int !Bool !PosLength   -- (or `__float128',
                                                 -- `__fp16',
                                                 -- `_Float{16,32,64,128}{,x}`)
            | CTokFor      !PosLength            -- `for'
            | CTokGeneric  !PosLength            -- `_Generic'
            | CTokGoto     !PosLength            -- `goto'
            | CTokIf       !PosLength            -- `if'
            | CTokInline   !PosLength            -- `inline'
                                                -- (or `__inline',
                                                -- `__inline__')
            | CTokInt      !PosLength            -- `int'
            | CTokInt128   !PosLength            -- `__int128`
                                                 -- (or `__int128_t`)
            | CTokLong     !PosLength            -- `long'
            | CTokLabel    !PosLength            -- `__label__
            | CTokNoreturn !PosLength            -- `_Noreturn'
            | CTokNullable !PosLength            -- `_Nullable'
            | CTokNonnull  !PosLength            -- `_Nonnull'
            | CTokRegister !PosLength            -- `register'
            | CTokRestrict !PosLength            -- `restrict'
                                                -- (or `__restrict',
                                                -- `__restrict__')
            | CTokReturn   !PosLength            -- `return'
            | CTokShort    !PosLength            -- `short'
            | CTokSigned   !PosLength            -- `signed'
                                                -- (or `__signed',
                                                -- `__signed__')
            | CTokSizeof   !PosLength            -- `sizeof'
            | CTokStatic   !PosLength            -- `static'
            | CTokStaticAssert !PosLength        -- `_Static_assert'
            | CTokStruct   !PosLength            -- `struct'
            | CTokSwitch   !PosLength            -- `switch'
            | CTokTypedef  !PosLength            -- `typedef'
            | CTokTypeof   !PosLength            -- `typeof'
            | CTokThread   !PosLength            -- `__thread'
            | CTokUInt128  !PosLength            -- `__uint128`
                                                 -- (or `__uint128_t`)
            | CTokUnion    !PosLength            -- `union'
            | CTokUnsigned !PosLength            -- `unsigned'
            | CTokVoid     !PosLength            -- `void'
            | CTokVolatile !PosLength            -- `volatile'
                                                -- (or `__volatile',
                                                -- `__volatile__')
            | CTokWhile    !PosLength            -- `while'
            | CTokCLit     !PosLength !CChar     -- character constant
            | CTokILit     !PosLength !CInteger  -- integer constant
            | CTokFLit     !PosLength CFloat     -- float constant
            | CTokSLit     !PosLength CString    -- string constant
            | CTokIdent    !PosLength !Ident     -- identifier

              -- not generated here, but in `CParser.parseCHeader'
            | CTokTyIdent  !PosLength !Ident     -- `typedef-name' identifier
            | CTokGnuC !GnuCTok !PosLength       -- special GNU C tokens
            | CTokClangC !PosLength !ClangCTok   -- special Clang C tokens
            | CTokClKernel !PosLength            -- OpenCL `__kernel'
            | CTokClRdOnly !PosLength            -- OpenCL `__read_only'
            | CTokClWrOnly !PosLength            -- OpenCL `__write_only'
            | CTokClGlobal !PosLength            -- OpenCL `__Global'
            | CTokClLocal  !PosLength            -- OpenCL `__Local'
            | CTokEof                           -- end of file

-- special tokens used in GNU C extensions to ANSI C
--
data GnuCTok = GnuCAttrTok              -- `__attribute__'
             | GnuCExtTok               -- `__extension__'
             | GnuCVaArg                -- `__builtin_va_arg'
             | GnuCOffsetof             -- `__builtin_offsetof'
             | GnuCTyCompat             -- `__builtin_types_compatible_p'
             | GnuCComplexReal          -- `__real__'
             | GnuCComplexImag          -- `__imag__'

data ClangCTok = ClangCVersionTok !ClangCVersion -- version constant from 'availability' attribute
               | ClangBuiltinConvertVector
               | ClangCBitCast                   -- `__builtin_bit_cast`

instance Pos CToken where
  posOf = fst . posLenOfTok

-- token position and length
posLenOfTok :: CToken -> (Position,Int)
posLenOfTok (CTokLParen   pos  ) = pos
posLenOfTok (CTokRParen   pos  ) = pos
posLenOfTok (CTokLBracket pos  ) = pos
posLenOfTok (CTokRBracket pos  ) = pos
posLenOfTok (CTokArrow    pos  ) = pos
posLenOfTok (CTokDot      pos  ) = pos
posLenOfTok (CTokExclam   pos  ) = pos
posLenOfTok (CTokTilde    pos  ) = pos
posLenOfTok (CTokInc      pos  ) = pos
posLenOfTok (CTokDec      pos  ) = pos
posLenOfTok (CTokPlus     pos  ) = pos
posLenOfTok (CTokMinus    pos  ) = pos
posLenOfTok (CTokStar     pos  ) = pos
posLenOfTok (CTokSlash    pos  ) = pos
posLenOfTok (CTokPercent  pos  ) = pos
posLenOfTok (CTokAmper    pos  ) = pos
posLenOfTok (CTokShiftL   pos  ) = pos
posLenOfTok (CTokShiftR   pos  ) = pos
posLenOfTok (CTokLess     pos  ) = pos
posLenOfTok (CTokLessEq   pos  ) = pos
posLenOfTok (CTokHigh     pos  ) = pos
posLenOfTok (CTokHighEq   pos  ) = pos
posLenOfTok (CTokEqual    pos  ) = pos
posLenOfTok (CTokUnequal  pos  ) = pos
posLenOfTok (CTokHat      pos  ) = pos
posLenOfTok (CTokBar      pos  ) = pos
posLenOfTok (CTokAnd      pos  ) = pos
posLenOfTok (CTokOr       pos  ) = pos
posLenOfTok (CTokQuest    pos  ) = pos
posLenOfTok (CTokColon    pos  ) = pos
posLenOfTok (CTokAssign   pos  ) = pos
posLenOfTok (CTokPlusAss  pos  ) = pos
posLenOfTok (CTokMinusAss pos  ) = pos
posLenOfTok (CTokStarAss  pos  ) = pos
posLenOfTok (CTokSlashAss pos  ) = pos
posLenOfTok (CTokPercAss  pos  ) = pos
posLenOfTok (CTokAmpAss   pos  ) = pos
posLenOfTok (CTokHatAss   pos  ) = pos
posLenOfTok (CTokBarAss   pos  ) = pos
posLenOfTok (CTokSLAss    pos  ) = pos
posLenOfTok (CTokSRAss    pos  ) = pos
posLenOfTok (CTokComma    pos  ) = pos
posLenOfTok (CTokSemic    pos  ) = pos
posLenOfTok (CTokLBrace   pos  ) = pos
posLenOfTok (CTokRBrace   pos  ) = pos
posLenOfTok (CTokEllipsis pos  ) = pos
posLenOfTok (CTokAlignof  pos  ) = pos
posLenOfTok (CTokAlignas  pos  ) = pos
posLenOfTok (CTokAsm      pos  ) = pos
posLenOfTok (CTokAtomic   pos  ) = pos
posLenOfTok (CTokAuto     pos  ) = pos
posLenOfTok (CTokBreak    pos  ) = pos
posLenOfTok (CTokBool     pos  ) = pos
posLenOfTok (CTokCase     pos  ) = pos
posLenOfTok (CTokChar     pos  ) = pos
posLenOfTok (CTokConst    pos  ) = pos
posLenOfTok (CTokContinue pos  ) = pos
posLenOfTok (CTokComplex  pos  ) = pos
posLenOfTok (CTokDefault  pos  ) = pos
posLenOfTok (CTokDo       pos  ) = pos
posLenOfTok (CTokDouble   pos  ) = pos
posLenOfTok (CTokElse     pos  ) = pos
posLenOfTok (CTokEnum     pos  ) = pos
posLenOfTok (CTokExtern   pos  ) = pos
posLenOfTok (CTokFloat    pos  ) = pos
posLenOfTok (CTokBFloat16 pos  ) = pos
posLenOfTok (CTokFloatN _ _ pos) = pos
posLenOfTok (CTokFor      pos  ) = pos
posLenOfTok (CTokGeneric  pos  ) = pos
posLenOfTok (CTokGoto     pos  ) = pos
posLenOfTok (CTokInt      pos  ) = pos
posLenOfTok (CTokInt128   pos  ) = pos
posLenOfTok (CTokInline   pos  ) = pos
posLenOfTok (CTokIf       pos  ) = pos
posLenOfTok (CTokLong     pos  ) = pos
posLenOfTok (CTokLabel    pos  ) = pos
posLenOfTok (CTokNoreturn pos  ) = pos
posLenOfTok (CTokNullable pos  ) = pos
posLenOfTok (CTokNonnull  pos  ) = pos
posLenOfTok (CTokRegister pos  ) = pos
posLenOfTok (CTokRestrict pos  ) = pos
posLenOfTok (CTokReturn   pos  ) = pos
posLenOfTok (CTokShort    pos  ) = pos
posLenOfTok (CTokSigned   pos  ) = pos
posLenOfTok (CTokSizeof   pos  ) = pos
posLenOfTok (CTokStatic   pos  ) = pos
posLenOfTok (CTokStaticAssert pos) = pos
posLenOfTok (CTokStruct   pos  ) = pos
posLenOfTok (CTokSwitch   pos  ) = pos
posLenOfTok (CTokTypedef  pos  ) = pos
posLenOfTok (CTokTypeof   pos  ) = pos
posLenOfTok (CTokThread   pos  ) = pos
posLenOfTok (CTokUInt128  pos  ) = pos
posLenOfTok (CTokUnion    pos  ) = pos
posLenOfTok (CTokUnsigned pos  ) = pos
posLenOfTok (CTokVoid     pos  ) = pos
posLenOfTok (CTokVolatile pos  ) = pos
posLenOfTok (CTokWhile    pos  ) = pos
posLenOfTok (CTokCLit     pos _) = pos
posLenOfTok (CTokILit     pos _) = pos
posLenOfTok (CTokFLit     pos _) = pos
posLenOfTok (CTokSLit     pos _) = pos
posLenOfTok (CTokIdent    pos _) = pos
posLenOfTok (CTokTyIdent  pos _) = pos
posLenOfTok (CTokGnuC   _ pos  ) = pos
posLenOfTok (CTokClangC   pos _) = pos
posLenOfTok (CTokClKernel pos  ) = pos
posLenOfTok (CTokClRdOnly pos  ) = pos
posLenOfTok (CTokClWrOnly pos  ) = pos
posLenOfTok (CTokClGlobal pos  ) = pos
posLenOfTok (CTokClLocal  pos  ) = pos
posLenOfTok CTokEof = error "tokenPos: Eof"

instance Show CToken where
  showsPrec _ (CTokLParen   _  ) = showString "("
  showsPrec _ (CTokRParen   _  ) = showString ")"
  showsPrec _ (CTokLBracket _  ) = showString "["
  showsPrec _ (CTokRBracket _  ) = showString "]"
  showsPrec _ (CTokArrow    _  ) = showString "->"
  showsPrec _ (CTokDot      _  ) = showString "."
  showsPrec _ (CTokExclam   _  ) = showString "!"
  showsPrec _ (CTokTilde    _  ) = showString "~"
  showsPrec _ (CTokInc      _  ) = showString "++"
  showsPrec _ (CTokDec      _  ) = showString "--"
  showsPrec _ (CTokPlus     _  ) = showString "+"
  showsPrec _ (CTokMinus    _  ) = showString "-"
  showsPrec _ (CTokStar     _  ) = showString "*"
  showsPrec _ (CTokSlash    _  ) = showString "/"
  showsPrec _ (CTokPercent  _  ) = showString "%"
  showsPrec _ (CTokAmper    _  ) = showString "&"
  showsPrec _ (CTokShiftL   _  ) = showString "<<"
  showsPrec _ (CTokShiftR   _  ) = showString ">>"
  showsPrec _ (CTokLess     _  ) = showString "<"
  showsPrec _ (CTokLessEq   _  ) = showString "<="
  showsPrec _ (CTokHigh     _  ) = showString ">"
  showsPrec _ (CTokHighEq   _  ) = showString ">="
  showsPrec _ (CTokEqual    _  ) = showString "=="
  showsPrec _ (CTokUnequal  _  ) = showString "!="
  showsPrec _ (CTokHat      _  ) = showString "^"
  showsPrec _ (CTokBar      _  ) = showString "|"
  showsPrec _ (CTokAnd      _  ) = showString "&&"
  showsPrec _ (CTokOr       _  ) = showString "||"
  showsPrec _ (CTokQuest    _  ) = showString "?"
  showsPrec _ (CTokColon    _  ) = showString ":"
  showsPrec _ (CTokAssign   _  ) = showString "="
  showsPrec _ (CTokPlusAss  _  ) = showString "+="
  showsPrec _ (CTokMinusAss _  ) = showString "-="
  showsPrec _ (CTokStarAss  _  ) = showString "*="
  showsPrec _ (CTokSlashAss _  ) = showString "/="
  showsPrec _ (CTokPercAss  _  ) = showString "%="
  showsPrec _ (CTokAmpAss   _  ) = showString "&="
  showsPrec _ (CTokHatAss   _  ) = showString "^="
  showsPrec _ (CTokBarAss   _  ) = showString "|="
  showsPrec _ (CTokSLAss    _  ) = showString "<<="
  showsPrec _ (CTokSRAss    _  ) = showString ">>="
  showsPrec _ (CTokComma    _  ) = showString ","
  showsPrec _ (CTokSemic    _  ) = showString ";"
  showsPrec _ (CTokLBrace   _  ) = showString "{"
  showsPrec _ (CTokRBrace   _  ) = showString "}"
  showsPrec _ (CTokEllipsis _  ) = showString "..."
  showsPrec _ (CTokAlignof  _  ) = showString "alignof"
  showsPrec _ (CTokAlignas  _  ) = showString "_Alignas"
  showsPrec _ (CTokAsm      _  ) = showString "asm"
  showsPrec _ (CTokAtomic      _  ) = showString "_Atomic"
  showsPrec _ (CTokAuto     _  ) = showString "auto"
  showsPrec _ (CTokBool _)       = showString "_Bool"
  showsPrec _ (CTokBreak    _  ) = showString "break"
  showsPrec _ (CTokCase     _  ) = showString "case"
  showsPrec _ (CTokChar     _  ) = showString "char"
  showsPrec _ (CTokComplex _)    = showString "_Complex"
  showsPrec _ (CTokConst    _  ) = showString "const"
  showsPrec _ (CTokContinue _  ) = showString "continue"
  showsPrec _ (CTokDefault  _  ) = showString "default"
  showsPrec _ (CTokDouble   _  ) = showString "double"
  showsPrec _ (CTokDo       _  ) = showString "do"
  showsPrec _ (CTokElse     _  ) = showString "else"
  showsPrec _ (CTokEnum     _  ) = showString "enum"
  showsPrec _ (CTokExtern   _  ) = showString "extern"
  showsPrec _ (CTokFloat    _  ) = showString "float"
  showsPrec _ (CTokBFloat16 _  ) = showString "__bf16"
  showsPrec _ (CTokFloatN n x _) = showString "_Float" . shows n .
                                   showString (if x then "x" else "")
  showsPrec _ (CTokFor      _  ) = showString "for"
  showsPrec _ (CTokGeneric  _  ) = showString "_Generic"
  showsPrec _ (CTokGoto     _  ) = showString "goto"
  showsPrec _ (CTokIf       _  ) = showString "if"
  showsPrec _ (CTokInline   _  ) = showString "inline"
  showsPrec _ (CTokInt      _  ) = showString "int"
  showsPrec _ (CTokInt128   _  ) = showString "__int128"
  showsPrec _ (CTokLong     _  ) = showString "long"
  showsPrec _ (CTokLabel    _  ) = showString "__label__"
  showsPrec _ (CTokNoreturn    _  ) = showString "_Noreturn"
  showsPrec _ (CTokNullable    _  ) = showString "_Nullable"
  showsPrec _ (CTokNonnull     _  ) = showString "_Nonnull"
  showsPrec _ (CTokRegister _  ) = showString "register"
  showsPrec _ (CTokRestrict _  ) = showString "restrict"
  showsPrec _ (CTokReturn   _  ) = showString "return"
  showsPrec _ (CTokShort    _  ) = showString "short"
  showsPrec _ (CTokSigned   _  ) = showString "signed"
  showsPrec _ (CTokSizeof   _  ) = showString "sizeof"
  showsPrec _ (CTokStatic   _  ) = showString "static"
  showsPrec _ (CTokStaticAssert   _  ) = showString "_Static_assert"
  showsPrec _ (CTokStruct   _  ) = showString "struct"
  showsPrec _ (CTokSwitch   _  ) = showString "switch"
  showsPrec _ (CTokTypedef  _  ) = showString "typedef"
  showsPrec _ (CTokTypeof   _  ) = showString "typeof"
  showsPrec _ (CTokThread   _  ) = showString "_Thread_local"
  showsPrec _ (CTokUInt128  _  ) = showString "__uint128"
  showsPrec _ (CTokUnion    _  ) = showString "union"
  showsPrec _ (CTokUnsigned _  ) = showString "unsigned"
  showsPrec _ (CTokVoid     _  ) = showString "void"
  showsPrec _ (CTokVolatile _  ) = showString "volatile"
  showsPrec _ (CTokWhile    _  ) = showString "while"
  showsPrec _ (CTokCLit     _ c) = shows c
  showsPrec _ (CTokILit     _ i) = shows i
  showsPrec _ (CTokFLit     _ f) = shows f
  showsPrec _ (CTokSLit     _ s) = shows s
  showsPrec _ (CTokIdent    _ i) = (showString . identToString) i
  showsPrec _ (CTokTyIdent  _ i) = (showString . identToString) i
  showsPrec _ (CTokGnuC GnuCAttrTok _) = showString "__attribute__"
  showsPrec _ (CTokGnuC GnuCExtTok  _) = showString "__extension__"
  showsPrec _ (CTokGnuC GnuCComplexReal _) = showString "__real__"
  showsPrec _ (CTokGnuC GnuCComplexImag  _) = showString "__imag__"
  showsPrec _ (CTokGnuC GnuCVaArg    _) = showString "__builtin_va_arg"
  showsPrec _ (CTokGnuC GnuCOffsetof _) = showString "__builtin_offsetof"
  showsPrec _ (CTokGnuC GnuCTyCompat _) = showString "__builtin_types_compatible_p"
  showsPrec _ (CTokClangC _ (ClangCVersionTok v)) = shows v
  showsPrec _ (CTokClangC _ ClangBuiltinConvertVector) = showString "__builtin_convertvector"
  showsPrec _ (CTokClangC _ ClangCBitCast) = showString "__builtin_bit_cast"
  showsPrec _ (CTokClKernel _  ) = showString "__kernel"
  showsPrec _ (CTokClRdOnly _  ) = showString "__read_only"
  showsPrec _ (CTokClWrOnly _  ) = showString "__write_only"
  showsPrec _ (CTokClGlobal _  ) = showString "__global"
  showsPrec _ (CTokClLocal  _  ) = showString "__Local"
  showsPrec _ CTokEof = error "show CToken : CTokEof"
