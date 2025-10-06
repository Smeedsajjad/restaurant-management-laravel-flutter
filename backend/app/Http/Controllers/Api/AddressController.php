<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\AddressResource;
use App\Models\Address;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class AddressController extends Controller
{
    use ApiResponse;
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $addresses = Address::where('user_id', $request->user()->id)->with('user')->get();
        return $this->success(AddressResource::collection($addresses), 'Addresses fetched successfully');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'label' => 'required|string|max:255',
            'street' => 'required|string|max:255',
            'city' => 'required|string|max:255',
            'country' => 'required|string|max:255',
            'is_default' => 'boolean',
        ]);

        if (!empty($validated['is_default']) && $validated['is_default']) {
            Address::where('user_id', $request->user()->id)->update(['is_default' => false]);

        }

        $address = Address::create([
            'user_id' => $request->user()->id,
            ...$validated,
        ]);

        return $this->created(new AddressResource($address), 'Address added successfully');

    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Address $address)
    {
        if ($address->user_id !== $request->user()->id) {
            return $this->unauthorized('You do not own this address');
        }
        $validated = $request->validate([
            'label' => 'required|string|max:255',
            'street' => 'required|string|max:255',
            'city' => 'required|string|max:255',
            'country' => 'required|string|max:255',
            'is_default' => 'boolean',
        ]);

        if (!empty($validated['is_default']) && $validated['is_default']) {
            Address::where('user_id', $request->user()->id)->update(['is_default' => false]);

        }

        $address->update($validated);

        return $this->success(new AddressResource($address), 'Address updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, Address $address)
    {
        if ($address->user_id !== $request->user()->id) {
            return $this->unauthorized('You do not own this address');
        }
        $address->delete();
        return $this->success(null, 'Address deleted successfully');
    }
}
