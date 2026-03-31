;; generate pixel art in vituoso layout

procedure( fill_pixel(cv type ll ur colorType)
    dbCreateRect(cv list(colorTable[type] "drawing") list(ll ur))
) ; fill_pixel


procedure( genpsyduck(libname pixel_size gap pixel_map_file)
    let( (size colorTable (xMax 36) (yMax 36))
    size = pixel_size
    initPos = 0:((yMax-1)*size)+gap*(yMax-1)
    
    ;; change the metal layers according to what's available to you
    colorTable = makeTable("colorTable" nil)
    colorTable[1] = "metal1" ;bg - blue/purple 
    colorTable[2] = "cont" ;beak - orange
    colorTable[3] = "via2" ;body - yellow
    colorTable[4] = "diff" ;border - black
    colorTable[5] = "via" ;whiteborder white
    colorTable[6] = "metal3" ;star green

    targetcv = dbOpenCellViewByType(libname "psyduck" "layout" "maskLayout" "w")

    mapPort = infile(pixel_map_file)
    ll = initPos
    for(i 1 yMax
        rowList = lineread(mapPort)
        ll = 0:((yMax-1)*size)+gap(yMax-1) -gap*(i-1) -size*(i-1)
        for(j 1 xMax
            pixelBlock = car(rowList)
            new_x = xCoord(ll) + (j-1)*size + (j-1)*gap
            ur = new_x+size : yCoord(ll)+size
            fill_pixel(targetcv pixelBlock new_x:yCoord(ll) ur colorTable)
            rowList = cdr(rowList)
        ); for x
    ); for y
    close(mapPort)
    dbSave(targetcv)
    dbClose(targetcv)
    t
    ); let

) ; genpsyduck

;;;; function call example  - genpsyduck("master" 10 2 "<path to pixelmap.txt>)
genpsyduck("master" 10 2 pixelmap.txt)
