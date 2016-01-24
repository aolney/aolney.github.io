---
layout: post
section-type: post
title: Minimum Spanning Tree - C# source code
category: Category
tags: [ 'research', 'publications', 'dissertation','nlp','semantics' ]
---

Minimum spanning tree algorithms have interesting implications for dependency parsing (McDonald et al 2005)

In previous work on unsupervised grammar induction, I use this MST algorithm to determine which links are "best" using a semantic head relatedness criterion. At the time I was surprised by how little code was available besides the obvious and slow O(n^3).

The linked code is [adapted from C++](http://www.di.unipi.it/optimize/Software/MSA.html) and has a nice O(n^2) property. 

{% highlight csharp %}
#region Contributions and License
/*	C# conversion by Andrew Olney
	Version 1
	January 19, 2006
	See following header for past credits and licensing details
*/

/*--------------------------------------------------------------------------*/
/*-------------------------- File MSArbor.h --------------------------------*/
/*--------------------------------------------------------------------------*/
/** @file
 * Solves the Minimal Spanning Arborescence problem, with a C++
 * implementation of the ARBOR algorithm [M. Fischetti and P.Toth,
 * ORSA J. on Computing 5(4), 1993] for MSA on complete graphs.
 *
 * \version 1.12
 *
 * \date 14 - 10 - 2004
 *
 * \author Antonio Frangioni \n
 *         Operations Research Group \n
 *         Dipartimento di Informatica \n
 *         Universita' di Pisa \n
 *
 * \author Daniele Pretolani \n
 *         Dipartimento di Matematica \n
 *         Universita' di Camerino \n
 *
 * \author Marisa Traini \n
 *         Dipartimento di Matematica \n
 *         Universita' di Camerino \n
 *         
 *
 * Copyright (C) 2004
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
 * or check www.gnu.org.
 */
#endregion
namespace MSA_di_unipi_it
{
	/// <summary>
	/// Given a (complete) directed graph G = ( N , A ), with n = |N| nodes and
	/// m = |A| (= n ( n - 1 )) arcs, and arc costs initialCosts[ i , j ], the Minimal
	/// Spanning Arborescence problem (MSA) with root r requires to find a
	/// directed spanning tree (arborescence) of G rooted in r with minimal
	/// total cost, where the cost is the sum of the costs of the arcs belonging
	/// to the tree.

	/// This class solves MSA for r = n - 1 (the node with largest index) with a
	/// C++ implementation of the ARBOR algorithm [M. Fischetti and P.Toth,
	/// ORSA J. on Computing 5(4), 1993] for complete graphs.

	/// Nodes and arc indices are defined to be of the public type MSArbor::Index,
	/// and arc costs are defined to be of the public type MSArbor::CNumber.
	/// These types, with the accompanying constants InINF and C_INF, are defined
	/// in the public types part of the class. By changing these definitions one
	/// can a) solve compilation problems due to different type or constant names
	/// in differend compilers, and b) use "small" date types, just large enough
	/// to fit the numbers in his/her instances, thereby (possibly) reducing the
	/// memory footprint of the object and increasing its efficiency. 
	/// </summary>
	public class MSArbor
	{
		#region Fields
		public bool exceptionThrown = false;

		//Constants
		public const ushort SCAN = 0;
		public const ushort LOOP = 1;
		public const ushort RCON = 2;
		/// <summary>
		/// the largest node and arc Index, 0 to InINF
		/// </summary>
		public readonly ushort InINF = 65535;
        /// <summary>
        /// the largest arc cost, -C_INF to +C_INF
        /// </summary>
		public readonly short C_INF = 32767;           
		/// <summary>
		/// Flag to trigger correctness checking, which prints to screen
		/// </summary>
		public bool LOG_MSA = true;
		/// <summary>
		/// Total number of nodes of the graph
		/// </summary>
		protected ushort  numberNodes;
        /// <summary>
        /// size of the dual tree (<= 2 numberNodes - 2)
        /// </summary>
		protected ushort  dualTreeSize;  
        /// <summary>
        /// numberNodes - 1
        /// </summary>
		protected ushort  root;              
		/// <summary>
		/// ( numberNodes - 1 ) * numberNodes : size of the cost array
		/// </summary>
		protected ushort  costArraySize;     
		/// <summary>
		/// 2 * numberNodes - 3 : max number of nodes in the auxiliary tree, i.e. original nodes plus supernodes 
		/// representing strongly connected components
		/// </summary>
		protected ushort  auxTreeMaxNodes;     
		/// <summary>
		///  numberNodes array, predecessor function of the optimal tree
		/// </summary>
		protected ushort[] predecessorFunction;      
		/// <summary>
		/// ( numberNodes - 1 ) * numberNodes  matrix: initially, row j gives the
		/// costs of arcs in (Backward Stars) BS( j ), arcCosts( i , i ) == +INF, and the root has no BS
		/// </summary>
		protected short[] arcCosts;    
		/// <summary>
		/// ( 2 numberNodes - 2 ) array. dualVariables[ j ] == dual variable associated with node j
		/// </summary>
		protected short[] dualVariables;          
		/// <summary>
		/// numberNodes array. LABEL[ j ] == stage where node j is labeled
		/// </summary>
		protected ushort[] LABEL; 
		/// <summary>
		/// ( 2 numberNodes - 2 ) array. PARENT[ j ] == predecessor of j in the auxiliary tree
		/// </summary>
		protected ushort[] PARENT; 
		/// <summary>
		/// ( 2 numberNodes - 2 ) arrays: ARC*[ j ] == Tail of original arc entering node j 
		/// (when j is visited)
		/// </summary>
		protected ushort[] ARCT;
		/// <summary>
		/// ( 2 numberNodes - 2 ) arrays: ARC*[ j ] == Head of original arc entering node j 
		/// (when j is visited)
		/// </summary>
		protected ushort[] ARCH;    
		/// <summary>
		/// ( 2 numberNodes - 2 ) array. LINE[ j ] == (cost) line index associated with node j
		/// </summary>
		protected ushort[] LINE;  
		/// <summary>
		/// numberNodes array: SHADOW[ h ] == (arc) line index associated with node j with LINE[ j ] == h
		/// </summary>
		protected ushort[] SHADOW;  
		/// <summary>
		/// ( numberNodes - 1 ) array: stack of labeled nodes
		/// </summary>
		protected ushort[] STACK;
		/// <summary>
		/// ( 2 numberNodes - 2 ) array: set of nodes in the current graph;
		/// original nodes are in cells [ Abot .. numberNodes - 1 ];
		/// shrunken nodes in cells [ numberNodes .. Atop ]
		/// </summary>
		protected ushort[] ACTIVE; 
		/// <summary>
		/// ( 2 numberNodes - 2 ) array. POS[ j ] == position of node j in ACTIVE;
		///  if j is not in the current graph, then POS[ j ] == UNDEFINED
		/// </summary>
		protected ushort[] POS;
		#endregion
		#region Conversion notes
		//The original Index maps to ushort, Index_Set to ushort[]
		//The original cIndex maps to readonly ushort, cIndex_Set to readonly ushort[]
		//The orginal CNumber maps to short 
		// type of arc costs: since the
		//cost matrix is re-used to storenode names, it not should be
		//	(too) "smaller" than Index */
		//The orginal CRow maps to short[]
		//The original cCNumber maps to readonly short
		//The original cCRow maps to readonly short[]
		//The original FONumber maps to int
		//< type of objective function
		//values; should be able to hold
		//something like <max arc cost>
		//times <max number of nodes> 
		#endregion
		#region Constructor
		/// <summary>
		/// Constructor of the class: takes as parameter the number of nodes in the
		/// graph G. The actual graph is passed in Solve() [see below], and different
		/// instances can be solved by calling Solve() multiple times on the same
		/// MSArbor object, as long as al the instances have the same number of nodes.
		/// </summary>
		/// <param name="numberNodes"></param>
		public MSArbor( ushort numberNodes )
		{
			// define dimensions - - - - - - - - - - - - - - - - - - - - - - - - - - - -

			this.numberNodes = numberNodes;
			this.root = ( ushort )( numberNodes - 1 );
			this.costArraySize = ( ushort )( root * numberNodes );
			this.auxTreeMaxNodes = ( ushort )( 2 * numberNodes - 2 );

			// allocate memory - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

			this.dualVariables = new short[ auxTreeMaxNodes ];
			this.arcCosts      = new short[ costArraySize ];
			this.predecessorFunction      = new ushort[ numberNodes ];
			SHADOW = new ushort[ numberNodes ];
			STACK  = new ushort[ numberNodes ];
			ACTIVE = new ushort[ auxTreeMaxNodes ];
			POS    = new ushort[ auxTreeMaxNodes ];
			LABEL  = new ushort[ auxTreeMaxNodes ];
			PARENT = new ushort[ auxTreeMaxNodes ];
			ARCT   = new ushort[ auxTreeMaxNodes ];
			ARCH   = new ushort[ auxTreeMaxNodes ];
			LINE   = new ushort[ auxTreeMaxNodes ];

		}

		#endregion
		#region Methods
		/// <summary>
		/// This method solves the Minimum Spanning Arborescence problem on the
		///complete graph described in the vector initialCosts[], which is a vector of arc
		///  costs, ordered as follows:
		///
		///- a sequence of n - 1 Backward Stars: BS[ 0 ], BS[ 1 ], .., BS[ n - 2 ]; 
		/// -->ANDREW: (inbound edges of a vertex == backwards star / outbound edges == forward star)
		/// -->ANDREW: In the input file, the cost of edge from 14 to 0 is at row 14 col 0, but that is rearranged when 
		/// -->		the file is read in, so that initialCosts[ i + n * j ] is the cost of ( i , j )
		///- arcs in each BS[ i ] are ordered in increasing index of tail node;
		///
		///Since nodes are numbered from 0 to n - 1, and the root is node n - 1,
		///initialCosts[ i + n * j ] is the cost of ( i , j ). BS[ root ] does not exist.
		///
		/// Although the algorithm is developed with complete graphs in mind, it
		///   is possible to solve non-complete instances by giving not-existent arcs
		/// the "plus infinity" cost C_INF [see below].
		///
		///\warning in the current version, no attempt is made to check whether a
		/// feasible solution (*not* using arcs with cost C_INF) exists: if
		///such a solution does not exist, the results are UNPREDICTABLE.
		///
		///If CR != 0 (= NULL), after that the Minimum Spanning Arborescence has been
		///	  found its optimal arc reduced costs are written in CR, in the same format
		///	 as the arc cost vector initialCosts.
		///
		///\warning the current implementation of the reduced cost computation is a
		///   "naive" one, which has an O(n^3) worst case complexity; a smarter 
		///   O(n^2) implementation is possible, but it is not implemented as 
		///yet. Note that the MSA computation has an O(n^2) cost. */
		/// </summary>
		/// <param name="initialCosts"></param>
		/// <returns></returns>
		public int Solve( short[] initialCosts )
		{
			#region Initialize
			//short[] RC = null;

			dualTreeSize = root;

			//Copy initialCosts to this.arcCosts
			ushort i;
			for( i = 0; i < this.costArraySize; i++ )
				this.arcCosts[ i ] = initialCosts[ i ];
			
			//Initialize these arrays
			i = 0;
			for( ; i <= root ; ) 
			{
				PARENT[ i ] = ARCT[ i ] = ARCH[ i ] = SHADOW[ i ] = predecessorFunction[ i ] = InINF; 
				LINE[ i ] = ACTIVE[ i ] = POS[ i ] = i;
				dualVariables[ i ] = 0;
				LABEL[ i++ ] = 0;
			}

			for( ; i <= 2 * numberNodes - 3 ; )
			{
				PARENT[ i ] = ARCT[ i ] = ARCH[ i ] = InINF;
				LINE[ i ] = i;
				dualVariables[ i ] = 0;
				POS[ i ] = 0;
				LABEL[ i++ ] = 0;
			}

			ushort Atop = root;
			ushort Abot = 0;
			ushort Ubot = 0;
			ushort Stage = LABEL[ root ] = 1;
			ushort UnLabeled = root;

			int Z = 0;
			#endregion
			#region Phase 1 

			ushort j;
			while( UnLabeled > 0 )
			{
				Stage++;  // a new stage begins

				// find first unlabeled active node

				if( Ubot < Abot )  // some nodes have been deleted
					Ubot = Abot;      // note: Ubot is non-decreasing 

				while( LABEL[ ACTIVE[ Ubot ] ] != 0 )
					Ubot++;

				ushort h = STACK[ 0 ] = ACTIVE[ Ubot ];
				ushort Stop = 0;
				ushort status;

				do
				{
					// process node v  at the top of the STACK

					ushort v = STACK[ Stop ];
					LABEL[ v ] = Stage;

					if( v < root )
						UnLabeled--; 

					ushort k1 = LINE[ v ];
					ushort kmin = 0, vmin = 0, t = 0;

					// find minimum arc ( t , v ) entering v

					short lmin = C_INF;
					status = LOOP; 

					j = Abot;
					for( ; j <= Atop ; )
					{
						// try arc ( i , v ): cost of ( i , v ) = arcCosts[ k1 , k2 ]

						i = ACTIVE[ j++ ];
						ushort k2 = LINE[ i ];
						ushort label2 = LABEL[ i ];

						short ctv = arcCosts[ k1 * numberNodes + k2 ];

						if( ctv < lmin )  // a new min cost arc is found
						{
							lmin = ctv; 
							kmin = k2; 
							t = i;

							if( label2 == Stage )
								status = LOOP;   // loop detected
							else
								if( label2 == 0 )
								status = SCAN;  // h unlabeled 
							else
								status = RCON;  // h r-linked  
						}
						else
							if( ctv == lmin )  // WARNING: some epsilon might be needed here
							if( ( label2 < Stage ) && ( label2 > 0 ) )
							{
								// i is a (currently) minimum r-connected node
								// choose i ONLY IF v is not already connected to the root;
								// this gives a solution with MAXIMUM root degree

								if( t != root )
								{
									kmin = k2;
									t = i;
									status = RCON;
								}
							}
							else
								if( ( status == LOOP ) && ( label2 == 0 ) )
							{
								// i is a minimum unlabeled node
								kmin = k2;
								t = i;
								status = SCAN;
							}
					}  // end for( j ): processing active node i

					// now, ( t , v ) is the minimum arc entering v: LINE[ t ] = kmin;
					// lmin = cost( t , v ); find the corresponding original arc
					// ( Tail , Head )

					if( k1 == v )  // v is an original node
						ARCH[ v ] = v;
					else           // v is a shrunken component
						ARCH[ v ] = ( ushort )( arcCosts[ SHADOW[ k1 ] * numberNodes + kmin ] );

					if( t == kmin )  // t is an original node
						ARCT[ v ] = t;
					else             // t is a shrunken component
						ARCT[ v ] =( ushort )( arcCosts[ k1 * numberNodes + SHADOW[ kmin ] ] );

					// update dual variables and objective function

					dualVariables[ v ] = lmin;
					Z += ( int )( lmin );

					if( status == SCAN )  // node t unlabeled; PUSH it on stack 
						STACK[ ++Stop ] = t; 
					else
						if( status == LOOP )  // a loop is detected; shrink a new component 
					{
						dualTreeSize++;  // new component name

						ushort h1 = 0;

						while( STACK[ h1 ] != t )
							h1++;

						// now, the nodes in the component are STACK[ h1 ] , STACK[ h1 + 1 ] ,
						// ... , STACK[ Stop ]: remove them from ACTIVE set

						for( j = h1 ; j <= Stop ; )
						{
							i = STACK[ j++ ];
							ushort k = POS[ i ];

							if( i > root )
							{
								ACTIVE[ k ] = ACTIVE[ Atop ];
								POS[ ACTIVE[ Atop-- ] ] = k;
							}
							else
							{
								ACTIVE[ k ] = ACTIVE[ Abot ];
								POS[ ACTIVE[ Abot++ ] ] = k;
							}

							PARENT[ i ] = dualTreeSize;

						}  // end for( j )

						// select new LINE and SHADOW: bottom and second nodes in STACK; 

						ushort Lm = LINE[ STACK[ h1 ] ];
						ushort Sm = LINE[ STACK[ h1 + 1 ] ];

						// - - - - - compute BS[ dualTreeSize ] - - - - - - - - - - - - - - - - - - - - - -

						for( j = Abot ; j <= Atop ; )
						{
							// process tail node i

							i = ACTIVE[ j++ ];
							ushort k2 = LINE[ i ];

							// process nodes in dualTreeSize

							lmin = C_INF;
							for( ushort k = h1 ; k <= Stop ; )
							{
								// try head node v; cost of ( i , v ) = arcCosts[ k1 , k2 ]

								v = STACK[ k++ ];
								k1 = LINE[ v ];

								short civ_prime = ( short )( arcCosts[ k1 * numberNodes + k2 ] - dualVariables[ v ] );

								if( civ_prime < lmin )  // a new min cost arc is found
								{
									lmin = civ_prime; 
									vmin = v; 
									kmin = k1;
								}
							}  // end for( k )

							v = vmin;

							// now, ( i , v ) is the minimum arc from i to dualTreeSize; LINE[ v ] = kmin; 

							arcCosts[ Lm * numberNodes + k2 ] = lmin; 

							// store the corresponding original arc in SHADOW

							if( v == kmin )         // v is an original node
								arcCosts[ Sm * numberNodes + k2 ] = ( short )v;  // put v in ROW Sm[ k2 ]
							else
								try
								{
									// v is a shrunken component
									arcCosts[ Sm * numberNodes + k2 ] = arcCosts[ SHADOW[ kmin ] * numberNodes + k2 ];
								}
								catch( System.Exception e )
								{
									System.Console.WriteLine( "Caught exception " + e.Message );
									this.exceptionThrown = true;
								}

							if( i != k2 )        // i is a shrunken component
							{
								ushort S2 = SHADOW[ k2 ];
								arcCosts[ Lm * numberNodes + S2 ] = arcCosts[ kmin * numberNodes + S2 ];
							} 

							// else i == k2 is an original node: do nothing

						}  // end for( j ): processing tail node i

						// - - - - - - - - compute FS[ dualTreeSize ] - - - - - - - - - - - - - - - - - - -

						j = Abot;
						if( j == root )
							j++;

						//for( ; j <= Atop ; ( j == ( root - 1 ) ? j += 2 : j++ ) )
						for( ; j <= Atop ; j += ( ushort )( j == ( root - 1 ) ? 2 : 1 ) )
						{
							// process head node i

							i = ACTIVE[ j ];
							ushort k2 = LINE[ i ];

							// process nodes in dualTreeSize

							lmin = C_INF;
							for( ushort k = h1 ; k <= Stop ; )
							{
								// try tail node v; cost of ( v , i ) = arcCosts[ k2 , k1 ] 

								v = STACK[ k++ ];
								k1 = LINE[ v ];

								short civ = arcCosts[ k2 * numberNodes + k1 ];

								if( civ < lmin )  // a new min cost arc is found
								{
									lmin = civ; 
									vmin = v; 
									kmin = k1;
								}
							}  // end for( k )

							v = vmin;
							// now, ( v , i ) is the minimum arc from dualTreeSize to i: LINE[ v ] = kmin; 

							arcCosts[ k2 * numberNodes + Lm ] = lmin; 
							// store the corresponding original arc in SHADOW

							if( v == kmin )         // v is an original node
								arcCosts[ k2 * numberNodes + Sm ] = ( short )v;  // put it in COLUMN Sm[ k2 ]
							else                    // v is a shrunken component; put arcCosts[ k2 , S1 ]
								// in COLUMN Sm[ k2 ]
								arcCosts[ k2 * numberNodes + Sm ] = arcCosts[ k2 * numberNodes + SHADOW[ kmin ] ];

							if( i != k2 )  // i is a shrunken component; put arcCosts[ S2 , k1 ]
							{              // in ROW S2[ Lm ]
								ushort S2 = SHADOW[ k2 ];
								arcCosts[ S2 * numberNodes + Lm ] = arcCosts[ S2 * numberNodes + kmin ];
							}

							// else i == k2 is an original node: do nothing

						}  // end for( j ): processing active node i, computation of FS( dualTreeSize )

						// insert dualTreeSize in the stack and in the ACTIVE set

						STACK[ Stop = h1 ] = ACTIVE[ ++Atop ] = dualTreeSize;

						// update LINE and SHADOW for new component

						SHADOW[ LINE[ dualTreeSize ] = Lm ] = Sm;

					}  // end if( Status == LOOP ) - End of Shrinking

				} while( ( status == LOOP ) || ( status == SCAN ) );   // End of the Stage

			}  // end while( UnLabeled > 0 )

			#endregion
			#region Phase 2 

			j = 0;
			for( ; j <= dualTreeSize ; ) 
				POS[ j++ ] = 0;     // note: POS is re-used to replace "REMOVED"

			POS[ root ] = 1;

			for( ushort Node = ( ushort )( dualTreeSize + 1 ); 0 != Node-- ; )
				if( POS[ Node ] == 0 )
				{
					ushort Head = ARCH[ Node ];
					ushort Tail = ARCT[ Node ];
					predecessorFunction[ Head ] = Tail;
					i = Head;

					while( i != Node )
					{
						POS[ i ] = 1;
						i = PARENT[ i ];
					}
				}

			#endregion
			#region Phase 3
			//Andrew note: I don't see how RC could ever be null in the original code, so I've commented this out
			/*
			if( RC != null )
			{
				// Compute reduced costs -- output on array RC with  numberNodes - 1 rows and numberNodes
				// columns (row == backward star, same format as the cost array).
				// For each arc ( i , j ), RC[ j , i ] gives the cost of ( i , j ) minus
				// the sum of the dual variables U( k ) for each r-cut k containing (i,j);
				// note that U( k ) is stored in U[ k ], where k is an index of a node in
				// the auxiliary tree, i.e. either an original node or a node representing
				// a Strongly Connected Component.
				//
				// ASSUMPTION: for each son k of the root of the auxiliary tree, it is
				//             PARENT[ k ] == InINF

				for( i = 0 ; i < 2 * numberNodes - 3 ; i++ )  // re-use arrays POS and ACTIVE
				{
					ACTIVE[ i ] = InINF;
					POS[ i ] = 0;
				}

				// l1 points to the first entry in RC (arc ( 0 , 0 )) - - - - - - - - - - -

				short[] l1 = RC;  
				short[] c1 = initialCosts;  
				for(  ushort Head = 0 ; Head < root ; Head++ )
					for(  ushort Tail = 0 ; Tail <= root ; Tail++ )
						if( ( Tail != Head ) && ( *c1 < C_INF ) )
						{
							// compute sum of dual variables for arc ( Tail , Head ) - - - - - - - -

							// (1) stack onto ACTIVE the nodes in the path from the root to node
							//     Head in the auxiliary tree; mark nodes setting POS = 1

							ushort k = 1;

							ACTIVE[ k ] = j = Head;
							POS[ j ] = k;

							while( PARENT[ j ] != InINF )
							{
								j = PARENT[ j ];  // climb up the tree

								ACTIVE[ ++k ] = j;
								POS[ j ] = k;
							}

							// (2) search the common ancestor of Tail and Head

							i = Tail;

							while( ( PARENT[ i ] != InINF ) && ( ! POS[ i ] ) )
								i = PARENT[ i ];

							if( POS[ i ] != 0 )      // Tail and Head have common ancestor i != root
								j = POS[ i ] - 1;
							else                // the common ancestor of Tail and Head is the root
								j = k;

							// (3) output in RC[ Head , Tail ] the cost of ( Tail , Head ) minus
							// the sum of the dual values for the ancestors of Head that are  
							// proper descendant of the common ancestor

							int RcHT = 0;
							for( ; j ; )
								RcHT += ( int )( dualVariables[ ACTIVE[ j-- ] ] );

							*(l1++) = ( short )( ( int )( *(c1++) ) - RcHT );

							// (4) clear POS

							for( ; k != 0; )
								POS[ ACTIVE[ k-- ] ] = 0;

						}    // end if( process arc ( Tail , Head ) )
						else  // either Tail == Head, or arcCosts( Tail , Head ) == C_INF: 
						{
							c1++;             // skip cost
							*(l1++) = C_INF;  // and set reduced cost to C_INF
						}

			}  // end if( RC != NULL )
*/
			#endregion
			#region correctness controls 
			//Andrew note: this section seems incomplete and will not compile
			/*
			if( this.LOG_MSA )
			{
				int NewZ = 0;       

				for( i = 0 ; i < root ; i++ )
				{
					j = predecessorFunction[ i ];
					ushort h = i * ( numberNodes - 1 ) + j;
					NewZ += ( int )( lambda[ h ] );
				}

				for( i = 0 ; i < root ; i++ )
				{
					ushort k = 0;
					j = i;

					while( j != root )
					{
						j = predecessorFunction[ j ];
						if( k++ > numberNodes )
							j = root;
					}

					if( k > numberNodes )
						System.Console.WriteLine( "ERROR: cycle on node " + i );
				}

				if( Z != NewZ )
					System.Console.WriteLine( "ERROR in the objective calculation (OPT = " + Z +
						", NewOPT = " + NewZ + ")" );
			}
			*/
			#endregion

			return( Z );

		}  // end( Solve )


		#endregion
		#region Properties
		/// <summary>
		/// Returns a read-only vector describing the primal optimal solution of the
		/// problem, i.e., the "predecessor" function of the optimal MSA.
		/// For each node i = 0, ..., n - 2, j = ReadPred()[ i ] is the predecessor of
		/// i in the spanning tree, and therefore arc (j, i) belongs to the optimal
		/// solution. The root has no predecessor, hence the entry n - 1 of the
		/// returned vector should not be checked. In effect, this gives us a list of ordered pairs, array index 
		/// and the value of the array at that index, such that the value is the label of a node that precedes 
		/// the node labeled by the index in the tree. E.g. p[ 0 ] = 5 means that 5 preceeds 0 in the tree, so 
		/// there is a directed edge from 5 to 0
		/// </summary>
		/// <returns></returns>
		public ushort[] ReadPred
		{
			get
			{ 
				return this.predecessorFunction;
			}
		}
	
		public ushort[] ReadAux
		{
			get
			{
				return this.PARENT;
			}
		}
	
		public ushort GetM
		{
			get
			{
				return this.dualTreeSize;
			}
		}
	
		public short[] GetU
		{
			get
			{
				return this.dualVariables;
			}
		}
	
		/*These three methods describe the dual optimal solution of the problem
		   (a good knowledge of the algorithm is required for understending their
		   meaning).

		   The dual optimal solution is described in terms of at most 2 n - 2 sets
		   of nodes, arranged in a tree structure (called the "auxiliary tree") and
		   with a dual variable attached to each. GetM() and ReadAux() describe the
		   topology of the auxiliary tree: GetM() returns the number of its nodes,
		   while ReadAux()[ i ] is the predecessor function of the tree. Note that 
		   the tree does not include a dummy root node, thus the sons of the dummy 
		   root have predecessor  InINF.  Finally, GetU()[ i ] is the value of the
		   optimal dual variable associated with the set (node of the auxiliary
		   tree) i. */

		/// <summary>
		/// Returns the size of the problem (number of nodes)
		/// </summary>
		public ushort GetN
		{
			get
			{
				return this.numberNodes;
			}
		}
		#endregion
	}
}
{% endhighlight %}


