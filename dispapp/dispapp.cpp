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
		hr = CoInitializeSecurity(NULL,
			-1,
			NULL,
			NULL,
			RPC_C_AUTHN_LEVEL_PKT,
			RPC_C_IMP_LEVEL_IMPERSONATE,
			NULL,
			EOAC_NONE,
			NULL);

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
					int hint = argc > 1 ? atoi(argv[1]) : 1;
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

					helloWorld->Release();
				}

				punk->Release();
			}

			CoUninitialize();
		}
	}

	if (FAILED(hr))
	{
		fprintf(stderr, "0x%lx\n", (long)hr);
	}

	return FAILED(hr);
}
