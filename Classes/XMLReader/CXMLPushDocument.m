//
//  CXMLPushDocument.m
//  dreaMote
//
//  Created by Moritz Venn on 31.12.08.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#ifdef LAME_ASYNCHRONOUS_DOWNLOAD

#import "CXMLPushDocument.h"

@implementation CXMLPushDocument

/* did we successfully parse the document? */
- (BOOL)success
{
	return _node != NULL;
}

/* dealloc */
- (void)dealloc
{
	if(_ctxt)
		xmlFreeParserCtxt(_ctxt);
	_ctxt = NULL;
	[super dealloc];
}

/* initialize */
- (id)initWithError: (NSError **)outError
{
	if((self = [super init]))
	{
		if(outError)
		{
			*outError = nil;
			_parseError = outError;
		}
	}
	else if(outError)
		*outError = [NSError errorWithDomain:@"CXMLErrorUnk" code:1 userInfo:NULL];

	return self;
}

/* parse a chunk of data */
- (void)parseChunk: (NSData *)chunk
{
	if(!_ctxt)
		_ctxt = xmlCreatePushParserCtxt(NULL, NULL, [chunk bytes], [chunk length], NULL);
	else
		xmlParseChunk(_ctxt, [chunk bytes], [chunk length], 0);
}

/* abort parsing */
- (void)abortParsing
{
	// Is this enough?
	if(_ctxt)
		xmlFreeParserCtxt(_ctxt);
	_ctxt = NULL;
}

/* finish parsing */
- (void)doneParsing
{
	if(!_ctxt)
	{
		if(_parseError)
			*_parseError = [NSError errorWithDomain:@"CXMLErrorUnk" code:1 userInfo:NULL];
		return;
	}

	xmlParseChunk(_ctxt, NULL, 0, 1);

	int res = _ctxt->wellFormed;
	if(res)
	{
		_node = (xmlNodePtr)_ctxt->myDoc;
		NSAssert(_node->_private == NULL, @"TODO");
		_node->_private = self; // Note. NOT retained (TODO think more about _private usage)
	}
	else
	{
		if(_parseError)
			*_parseError = [NSError errorWithDomain:@"CXMLErrorUnk" code:1 userInfo:NULL];
		_node = NULL;
	}

    xmlFreeParserCtxt(_ctxt);
	_ctxt = NULL;
}

@end

#endif
