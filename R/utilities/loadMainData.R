loadDat <- function(){
    
    nat.visit <- unlist(fromJSON(file = 'data/Customers_Visiting_Postcode.txt'))
    nat.visit <- data.table(postcode = names(nat.visit), visits = nat.visit)
    
    act.visit <- unlist(fromJSON(file = 'data/Customer_Visit_Data/Customers_Visiting_ACT.txt'))
    act.visit <- data.table(postcode = names(act.visit), visits = act.visit)
    
    nt.visit <- unlist(fromJSON(file = 'data/Customer_Visit_Data/Customers_Visiting_NT.txt'))
    nt.visit <- data.table(postcode = names(nt.visit), visits = nt.visit)
    
    qld.visit <- unlist(fromJSON(file = 'data/Customer_Visit_Data/Customers_Visiting_Queensland.txt'))
    qld.visit <- data.table(postcode = names(qld.visit), visits = qld.visit)
    
    sa.visit <- unlist(fromJSON(file = 'data/Customer_Visit_Data/Customers_Visiting_SA.txt'))
    sa.visit <- data.table(postcode = names(sa.visit), visits = sa.visit)
    
    vic.visit <- unlist(fromJSON(file = 'data/Customer_Visit_Data/Customers_Visiting_Victoria.txt'))
    vic.visit <- data.table(postcode = names(vic.visit), visits = vic.visit)
    
    wa.visit <- unlist(fromJSON(file = 'data/Customer_Visit_Data/Customers_Visiting_WA.txt'))
    wa.visit <- data.table(postcode = names(wa.visit), visits = wa.visit)
    
    loc.info <- fread('data/Australian_Post_Codes_Lat_Lon.csv')
    post.info <- fread('data/australian-postcodes.csv')
    post.info <- post.info[!(is.na(lat) | lat == 0)]
    
    dat <- list(visits = list(NAT = nat.visit,
                              ACT = act.visit,
                              NT = nt.visit,
                              QLD = qld.visit,
                              SA = sa.visit,
                              VIC = vic.visit,
                              WA = wa.visit),
                loc.info = loc.info,
                post.info = post.info
    )
    
    return(dat)
}
