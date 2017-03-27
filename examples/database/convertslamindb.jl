# convert uploaded graph in DB to MM-iSAM ready form

using Caesar, CloudGraphs


# Uncomment out for command line operation
# cloudGraph, addrdict = standardcloudgraphsetup(nparticles=true, clearslamindb=true)

# interactive operation
include(joinpath(dirname(@__FILE__),"blandauthremote.jl"))
addrdict["num particles"] = "100"
addrdict["session"] = "SESSLIVE"  # "SESSROX"
cloudGraph, addrdict = standardcloudgraphsetup(addrdict=addrdict)
addrdict["clearslamindb"] = "n"


session = addrdict["session"]
@show clearslamindbdata = addrdict["clearslamindb"]=="yes"

println("remember to set n.ready=1")
if !clearslamindbdata
  println("converting front end data")
  fg = Caesar.initfg(sessionname=session, cloudgraph=cloudGraph)
  Nparticles = parse(Int, addrdict["num particles"])
  updatenewverts!(fg, N=Nparticles)
else
  println("Clearing slamindb data, leaving front-end data, session: $(session)")
  resetentireremotesession(cloudGraph.neo4j.connection,session)
end


println("Done.")

# Juno.breakpoint("/home/dehann/.julia/v0.5/Caesar/src/cloudgraphs/CloudGraphIntegration.jl", 519 )

# Juno.breakpoint("/home/dehann/.julia/v0.5/IncrementalInference/src/FactorGraph01.jl",353)



# dd = getnewvertdict(fg.cg.neo4j.connection, session)




# using Neo4j
#
# conn = fg.cg.neo4j.connection
# loadtx = transaction(conn)
# query = "match (n:$(session))-[:DEPENDENCE]-(f:NEWDATA:$(session):FACTOR) where n.ready=1 or f.ready=1 return distinct n, f"
# cph = loadtx(query, submit=true)
