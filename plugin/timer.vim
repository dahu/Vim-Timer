let s:original_statusline = &statusline
set statusline=%!TimerStatusLine()
set ut=500 " can be anything less than s:timer_tick_ms
let s:timer_lasttime = reltime()
let s:timer_tick_ms = 1000
let g:timer_ticks = 0

augroup Timer
  au!
  au CursorHold    *  call TimerTick('n')
  au CursorMoved   *  call TimerTick('n')
augroup END

function! ActualStatusLine()
  "return "%f%m%r%h%w\ [%n:%{&ff}/%Y]%{Var('g:timer_ticks','')}%=[0x\%04.4B][%03v][%p%%\ line\ %l\ of\ %L]"
  return s:original_statusline
endfunction

function! TimerStatusLine()
  call TimerTick('')
  return ActualStatusLine()
endfunction

function! TimerTick(mode)
  " reltimestr() returns seconds.microseconds
  let l:now = str2float(reltimestr(reltime(s:timer_lasttime))) * 1000
  if l:now > s:timer_tick_ms
    let  g:timer_ticks += 1
    let  s:timer_lasttime = reltime()
    call TimerTickCallback(l:now)
  endif
  if (a:mode != '')
    call feedkeys(":\<CR>")
  endif
endfunction

if ! exists('*TimerTickCallback')
  function! TimerTickCallback(time)
  endfunction
endif
