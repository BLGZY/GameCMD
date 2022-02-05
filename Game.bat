@echo off&setlocal enabledelayedexpansion&title 2048&mode con: cols=32 lines=44&color F0
:startgame
if exist "2048JWinslow.dat" (for /f "delims=" %%g in (2048JWinslow.dat)do %%g) else set/ascore=0,winstate=0,bestscore=0&for /l %%g in (0,1,15)do set board[%%g]=0
set moves=0&set h=0&for /l %%g in (0,1,15)do if !board[%%g]!==0 set /a h+=1
if %h%==16 call :tilespawn&call :tilespawn
:startloop
if %score% gtr %bestscore% set bestscore=%score%
call :drawboard 0&call :savegame&choice /c wasdxn /n /m ""
if %errorlevel%==1 call :rotateclockwise&call :rotateclockwise&call :rotateclockwise&call :compress&call :merge&call :compress&call :compress&call :rotateclockwise
if %errorlevel%==2 call :compress&call :merge&call :compress&call :compress
if %errorlevel%==3 call :rotateclockwise&call :compress&call :merge&call :compress&call :compress&call :rotateclockwise&call :rotateclockwise&call :rotateclockwise
if %errorlevel%==4 call :rotateclockwise&call :rotateclockwise&call :compress&call :merge&call :compress&call :compress&call :rotateclockwise&call :rotateclockwise
if %errorlevel%==5 goto end
if %errorlevel%==6 (set score=0&set winstate=0&set moves=0&for /l %%g in (0,1,15)do set board[%%g]=0
call :tilespawn&call :tilespawn&goto startloop)
set/aboardchanged=0,tiles=0&for /l %%g in (0,1,15)do (if !board[%%g]! neq !tmpboard[%%g]! set boardchanged=1
if !board[%%g]! neq 0 set /a tiles+=1
if !board[%%g]!==2048 if %winstate%==0 set winstate=1)
if %boardchanged%==1 call :tilespawn&set/amoves+=1
if %winstate%==1 goto youwin
set/ayoulost=0,v=0
:1
set/av+=1
set/aw=%v%%%4,x=%v%/4,y=%v%-1,z=%v%-4
if %tiles%==15 (if %w% neq 0 if !board[%v%]!==!board[%y%]! set youlost=1
if %x% neq 0 if !board[%v%]!==!board[%z%]! set youlost=1)
if %tiles%==15 if %v% neq 15 goto 1
if %tiles%==15 if %youlost%==0 goto youlost
goto startloop
:tilespawn
set/arandtile=%random%%%16
if !board[%randtile%]! gtr 0 goto tilespawn
set/aboard[%randtile%]=%random%%%10/9*2+2&exit /b
:compress
set x=-1
:2
set/aw=0,x+=1,y=-1&for /l %%g in (0,1,3) do set tmparray[%%g]=0
:3
set/ay+=1&set/az=%x%*4+!y!
if !board[%z%]! neq 0 set/atmparray[%w%]=!board[%z%]!&set/aw+=1
if %y% neq 3 goto 3
for /l %%g in (0,1,3)do set/az=%x%*4+%%g&set/aboard[!z!]=!tmparray[%%g]!
if %x% neq 3 goto 2
exit /b
:merge
set x=-1
:4
set/ax+=1,y=-1
:5
set/ay+=1&set/aw=%x%*4+!y!&set/az=!w!+1
if !board[%w%]!==!board[%z%]! set/aboard[%w%]*=2,score+=!board[%w%]!&set board[%z%]=0
if %y% neq 2 goto 5
if %x% neq 3 goto 4
exit /b
:rotateclockwise
set i=12
for /l %%g in (0,1,15)do set/atmparray[%%g]=board[!i!],i-=4&if !i! lss 0 set/ai+=17
for /l %%g in (0,1,15)do set/aboard[%%g]=!tmparray[%%g]!
exit /b
:youwin
set winstate=2&call :drawboard 1&call :savegame&choice /c cnx /n /m ""
if %errorlevel%==1 goto startloop
if %errorlevel%==2 goto startgame
if %errorlevel%==3 exit /b
:youlost
call :drawboard 2&for /l %%g in (0,1,15)do set board[%%g]=0
set/ascore=0,winstate=0&call :savegame&choice /c nx /n /m ""
if %errorlevel%==1 goto startgame
if %errorlevel%==2 exit /b
:drawboard
for /l %%g in (0,1,15)do (set "board2[%%g]=      !board[%%g]!"&if !board[%%g]!==0 set "board2[%%g]=      "
if %moves% gtr 0 if %%g==%randtile% set board2[%%g]=   + !board[%%g]!
set board2[%%g]=!board2[%%g]:~-6!)
cls&echo  ___     ___    _  _      ___&echo ^|__ \   / _ \  ^| ^|^| ^|    / _ \&echo    ) ^| ^| ^| ^| ^| ^| ^|^| ^|_  ^| (_) ^|&echo   / /  ^| ^| ^| ^| ^|__   _^|  ^> _ ^<&echo  / /_  ^| ^|_^| ^|    ^| ^|   ^| (_) ^|&echo ^|____^|  \___/     ^|_^|    \___/&echo(&echo Join the numbers and get to the&echo            2048 tile^^!&echo(&if %1==0 echo     (Press N for new game)&echo(
if %1==1 echo             You Win!&echo Press C to continue, N to reset
if %1==2 echo            Game Over&echo     Press N to try again...
echo  Score: %score%&echo  Best: %bestscore%&echo  +------+------+------+------+&echo  ^|%board2[0]%^|%board2[1]%^|%board2[2]%^|%board2[3]%^|&echo  +------+------+------+------+&echo  ^|%board2[4]%^|%board2[5]%^|%board2[6]%^|%board2[7]%^|&echo  +------+------+------+------+&echo  ^|%board2[8]%^|%board2[9]%^|%board2[10]%^|%board2[11]%^|&echo  +------+------+------+------+&echo  ^|%board2[12]%^|%board2[13]%^|%board2[14]%^|%board2[15]%^|&echo  +------+------+------+------+&echo(&echo HOW TO PLAY: Use the WASD keys&echo to move the tiles. When two&echo tiles with the same number&echo touch, they merge into one^^!&echo -------------------------------&echo NOTE: This is only a port of&echo the original 2048, found at&echo [url]http://git.io/2048[/url] . Official&echo apps for iOS and Android are&echo also available. Other versions&echo are derivatives or fakes, and&echo should be used with caution.&echo -------------------------------&echo Port by Josiah Winslow. 2048&echo created by Gabriele Cirulli.&echo Based on 1024 by Veewo Studio&echo and conceptually similar to&echo Threes by Asher Vollmer.&exit /b
:savegame
echo(>2048JWinslow.dat&for %%g in (score bestscore winstate)do echo set %%g=!%%g!>>2048JWinslow.dat
for /l %%g in (0,1,15)do set tmpboard[%%g]=!board[%%g]!&echo set board[%%g]=!board[%%g]!>>2048JWinslow.dat
exit /b
:end
