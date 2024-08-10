/***********************************
 * Copyright (c) 2024 Roger Brown.
 * Licensed under the MIT License.
 ****/

#include <objbase.h>
#include <stdio.h>
#include <dispsvc_h.h>

int main(int argc, char** argv)
{
	HRESULT hr = CoInitializeEx(NULL, COINIT_MULTITHREADED);

	if (SUCCEEDED(hr))
	{
		IUnknown* punk = NULL;

		hr = GetActiveObject(CLSID_CHelloWorld, NULL, &punk);

		if (SUCCEEDED(hr))
		{
			IHelloWorld* helloWorld = NULL;

			hr = punk->QueryInterface(IID_IHelloWorld, (void**)&helloWorld);

			if (SUCCEEDED(hr))
			{
				hr = CoSetProxyBlanket(helloWorld, RPC_C_AUTHN_DEFAULT, RPC_C_AUTHZ_NONE, NULL, RPC_C_AUTHN_LEVEL_PKT, RPC_C_IMP_LEVEL_IMPERSONATE, NULL, EOAC_NONE);

				if (SUCCEEDED(hr))
				{
					int hint = 1;

					while (hint < 6)
					{
						BSTR result = NULL;

						hr = helloWorld->GetMessage(hint, &result);

						if (SUCCEEDED(hr))
						{
							printf("%S\n", result);

							if (result)
							{
								SysFreeString(result);
							}
						}
						else
						{
							break;
						}

						hint++;
					}

					helloWorld->Release();
				}
			}

			punk->Release();
		}

		CoUninitialize();
	}

	if (FAILED(hr))
	{
		fprintf(stderr, "0x%lx\n", (long)hr);
	}

	return FAILED(hr);
}
