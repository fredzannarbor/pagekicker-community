#!/usr/bin/python
#Filename: biased_lexrank.py


def b_lexrank(G, baseline_score, alpha = 0.85, personalization=None, max_iter=100, tol=1.0e-6, weight='weight', seed_weight = 1):
	""" Return the biased Lexrank scores of the nodes in the graph

		This program is based upon the pagerank_scipy program from the networkx 
		source.

	Parameters
	___________
	G: graph
		A NetworkX graph

	alpha: float, optional
		A damping parameter for PageRank, default = 0.85

	personalization: dict, optional
		The "personalization vector" consisting of a dictionary with a
		key for every graph node and nonzero personalization value for each node.

	max_iter : integer, optional
		Maximum number of iterations in power method eigenvalue solver.

	tol : float, optional
		Error tolerance used to check convergence in power method solver.

	weight : key, optional
		Edge data key to use as weight.  If None weights are set to 1.
	
	baseline_score: vector, float
		similarity scores between the seed and sentences within the graph



	Returns
	-------
	pagerank : dictionary
		Dictionary of nodes with PageRank as value

	Examples
	--------
		>>> G=nx.DiGraph(nx.path_graph(4))
		>>> pr=nx.pagerank_scipy(G,alpha=0.9)

	Notes
	-----
	The eigenvector calculation uses power iteration with a SciPy
	sparse matrix representation.


		References
		----------
		.. [1] A. Langville and C. Meyer,
		   "A survey of eigenvector methods of web information retrieval."
		   http://citeseer.ist.psu.edu/713792.html
		.. [2] Page, Lawrence; Brin, Sergey; Motwani, Rajeev and Winograd, Terry,
		   The PageRank citation ranking: Bringing order to the Web. 1999
		   http://dbpubs.stanford.edu:8090/pub/showDoc.Fulltext?lang=en&doc=1999-66&format=pdf
		   [3] Otterbacher, Erkan and Radev, Biased LexRank: Passage Retrieval using Random
		   Walks with Question-Based Priors (2008)
		"""

	try:
		import scipy.sparse
		import networkx as nx
		from numpy import diag
		from networkx.exception import NetworkXError
	except ImportError:
		raise ImportError("pagerank_scipy() requires SciPy: http://scipy.org/")
	if len(G) == 0:
		return {}
    # choose ordering in matrix
	if personalization is None: # use G.nodes() ordering
		nodelist=G.nodes()
	elif personalization is 'biased':
		nodelist = G.nodes()
	else:  # use personalization "vector" ordering
		nodelist=personalization.keys()
	M=nx.to_scipy_sparse_matrix(G,nodelist=nodelist,weight=weight,dtype='f')
	(n,m)=M.shape # should be square
	S=scipy.array(M.sum(axis=1)).flatten()
#    for i, j, v in zip( *scipy.sparse.find(M) ):
#        M[i,j] = v / S[i]
	S[S>0] = 1.0 / S[S>0]
	#creates a sparse diagonal matrix with normalization values
	Q = scipy.sparse.spdiags(S.T, 0, *M.shape, format='csr')
	M = Q * M
	x=scipy.ones((n))/n  # initial guess
	dangle=scipy.array(scipy.where(M.sum(axis=1)==0,1.0/n,0)).flatten()
	 # add "teleportation"/personalization
	if personalization is 'biased':
		v = scipy.array(baseline_score)
		v = v/v.sum()
		v = seed_weight * v/v.sum()
		#print v.shape
		
		
	elif personalization is not None:
	    v=scipy.array(list(personalization.values()),dtype=float)
	    v=v/v.sum()
	else:
	    v=x
	    #print v.shape
	  
	i=0
	while i <= max_iter:
	    # power iteration: make up to max_iter iterations
	    xlast=x
	    x=alpha*(x*M+scipy.dot(dangle,xlast))+(1-alpha)*v
	    x=x/x.sum()
	    # check convergence, l1 norm
	    err=scipy.absolute(x-xlast).sum()
	    if err < n*tol:
	        return dict(zip(nodelist,map(float,x)))
	    i+=1
	raise NetworkXError('pagerank_scipy: power iteration failed to converge'
	                    'in %d iterations.'%(i+1))
